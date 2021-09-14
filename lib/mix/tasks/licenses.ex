# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.Licenses do
  @moduledoc """
  Lists all dependencies along with a summary of their licenses.

  This task checks each entry in dependency package's `:licenses` list against the SPDX License List.

  To see details about licenses that are not found in the SPDX list, use `mix licenses.explain`.

  ## Command line options

    * `--osi` - additionally check if all licenses are approved by the [Open Source Initiative](https://opensource.org/licenses)

  """
  @shortdoc "Lists all dependencies along with a summary of their licenses."

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    check_osi_approved = "--osi" in args

    check =
      HexLicenses.license_check()
      |> Map.new(fn {dep, licenses} ->
        {dep, summary(licenses, check_osi_approved)}
      end)

    first_column_width =
      Map.keys(check)
      |> Enum.map(&to_string/1)
      |> Enum.map(&String.length/1)
      |> Enum.max(fn -> 0 end)
      |> max(String.length("Dependency"))
      |> Kernel.+(2)

    rows =
      Enum.sort_by(check, fn {dep, _summary} -> to_string(dep) end)
      |> Enum.map(fn {dep, summary} ->
        dep = String.pad_trailing(to_string(dep), first_column_width)

        IO.ANSI.format([dep, summary])
      end)

    header =
      IO.ANSI.format([:faint, String.pad_trailing("Dependency", first_column_width), "Status"])

    shell = Mix.shell()

    shell.info(header)
    Enum.each(rows, &shell.info/1)
  end

  defp summary(:not_in_hex, _check_osi_approved) do
    IO.ANSI.format([:red, "not in Hex"])
  end

  defp summary(licenses, check_osi_approved) when is_map(licenses) do
    values = Map.values(licenses)

    all_approved = Enum.all?(values, &(&1 == :osi_approved))
    count_not_approved = Enum.count(values, &(&1 == :not_approved))
    count_not_recognized = Enum.count(values, &(&1 == :not_recognized))

    check_passed? =
      (check_osi_approved && all_approved) or
        (count_not_recognized == 0)

    if check_passed? do
      pass_message(check_osi_approved)
    else
      fail_message(count_not_approved, count_not_recognized, check_osi_approved)
    end
  end

  defp pass_message(true), do: IO.ANSI.format([:green, "all OSI approved"])
  defp pass_message(false), do: IO.ANSI.format([:green, "all valid"])

  defp fail_message(count_not_approved, count_not_recognized, check_osi_approved) do
    not_approved_message = "#{count_not_approved} not OSI approved"
    not_recognized_message = "#{count_not_recognized} not recognized"

    message =
      cond do
        check_osi_approved && count_not_approved > 0 && count_not_recognized > 0 ->
          not_approved_message <> ", " <> not_recognized_message

        check_osi_approved && count_not_approved > 0 ->
          not_approved_message

        count_not_recognized > 0 ->
          not_recognized_message

      end

    IO.ANSI.format([:red, message])
  end
end
