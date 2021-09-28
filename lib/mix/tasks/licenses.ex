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
  alias HexLicenses.Check.{Deprecation, OSIApproval, SPDXListed}
  alias HexLicenses.Check

  @impl Mix.Task
  def run(args) do
    license_list =
      if "--update" in args do
        HexLicenses.SPDX.fetch_licenses()
        |> HexLicenses.SPDX.parse_licenses()
      else
        HexLicenses.SPDX.licenses()
      end

    checks = [
      SPDXListed.new(license_list),
      Deprecation.new(license_list)
    ]

    checks =
      if "--osi" in args do
        [OSIApproval.new(license_list) | checks]
      else
        checks
      end

    results =
      HexLicenses.license_check(checks)
      |> Map.new(fn {dep, results} ->
        {dep, summarize_all(results)}
      end)

    first_column_width =
      Map.keys(results)
      |> Enum.map(&to_string/1)
      |> Enum.map(&String.length/1)
      |> Enum.max(fn -> 0 end)
      |> max(String.length("Dependency"))
      |> Kernel.+(2)

    rows =
      Enum.sort_by(results, fn {dep, _summary} -> to_string(dep) end)
      |> Enum.map(fn {dep, summary} ->
        dep = String.pad_trailing(to_string(dep), first_column_width)
        [dep, summary]
      end)
      |> Enum.map(&IO.ANSI.format/1)

    header =
      IO.ANSI.format([:faint, String.pad_trailing("Dependency", first_column_width), "Status"])

    shell = Mix.shell()

    shell.info(header)
    Enum.each(rows, &shell.info/1)
  end

  defp summarize_all(results) do
    if Enum.all?(results, &Check.pass?/1) do
      IO.ANSI.format([:green, "all checks passed"])
    else
      str =
        Enum.map(results, &Check.failure_summary/1)
        |> Enum.join(", ")

      IO.ANSI.format([:red, str])
    end
  end
end
