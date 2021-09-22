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
    * `--update` - pull down a fresh copy of the SPDX license list instead of using the version checked in with this tool.

  """
  @shortdoc "Lists all dependencies along with a summary of their licenses."

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    check_osi_approved = "--osi" in args

    license_list =
      if "--update" in args do
        HexLicenses.SPDX.fetch_licenses()
        |> HexLicenses.SPDX.parse_licenses()
      else
        HexLicenses.SPDX.licenses()
      end

    check =
      HexLicenses.license_check(license_list)
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

    count_not_approved = Enum.count(values, &(&1 == :not_approved))
    count_not_recognized = Enum.count(values, &(&1 == :not_recognized))
    count_deprecated = Enum.count(values, &(&1 == :deprecated))

    osi_check_passed? =
      if check_osi_approved do
        count_not_approved == 0
      else
        true
      end

    id_check_passed? = count_not_recognized == 0
    deprecation_check_passed? = count_deprecated == 0

    check_passed? = osi_check_passed? && id_check_passed? && deprecation_check_passed?

    if check_passed? do
      if check_osi_approved do
        all_osi_approved_message()
      else
        all_valid_message()
      end
    else
      messages = []

      messages =
        if osi_check_passed? do
          messages
        else
          [not_osi_approved_message(count_not_approved) | messages]
        end

      messages =
        if id_check_passed? do
          messages
        else
          [not_recognized_message(count_not_recognized) | messages]
        end

      messages =
        if deprecation_check_passed? do
          messages
        else
          [deprecated_message(count_deprecated) | messages]
        end

      Enum.join(messages)
    end
  end

  defp all_osi_approved_message, do: IO.ANSI.format([:green, "all OSI approved"])
  defp all_valid_message, do: IO.ANSI.format([:green, "all valid"])
  defp not_osi_approved_message(count), do: IO.ANSI.format([:red, "#{count} not OSI approved"])
  defp not_recognized_message(count), do: IO.ANSI.format([:red, "#{count} not OSI approved"])
  defp deprecated_message(count), do: IO.ANSI.format([:red, "#{count} deprecated"])
end
