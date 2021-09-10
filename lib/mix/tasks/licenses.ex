# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.Licenses do
  @shortdoc "Checks if all your dependencies have valid licenses"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    check =
      HexLicenses.license_check()
      |> Map.new(fn {dep, licenses} ->
        {dep, summary(licenses)}
      end)

    first_column_width =
      Map.keys(check)
      |> Enum.map(&to_string/1)
      |> Enum.map(&String.length/1)
      |> Enum.max()
      |> max(String.length("Dependency"))
      |> Kernel.+(2)

    rows =
      Enum.map(check, fn {dep, summary} ->
        dep = String.pad_trailing(to_string(dep), first_column_width)

        IO.ANSI.format([dep, summary])
      end)

    header =  IO.ANSI.format([:faint, String.pad_trailing("Dependency", first_column_width), "Status"])

    shell = Mix.shell()

    shell.info(header)
    Enum.each(rows, &shell.info/1)
  end

  defp summary(licenses) do
    values = Map.values(licenses)

    if Enum.all?(values, &(&1 == :osi_approved)) do
      IO.ANSI.format([:green, "all OSI approved"])
    else
      count_not_approved = Enum.count(values, &(&1 == :not_approved))
      count_not_found = Enum.count(values, &(&1 == :not_found))


      not_approved_message = "#{count_not_approved} not OSI approved"
      not_found_message = "#{count_not_found} not found"


      message =
      cond do
        count_not_approved > 0 && count_not_found > 0 ->
          not_approved_message <> ", " <> not_found_message
        count_not_approved > 0 ->
          not_approved_message
        count_not_found > 0 ->
          not_found_message
      end

      IO.ANSI.format([:red, message])
    end
  end
end
