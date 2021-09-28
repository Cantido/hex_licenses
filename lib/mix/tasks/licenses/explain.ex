# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.Licenses.Explain do
  @moduledoc """
  Prints all dependencies with unrecognized or non-OSI-approved licenses.

  It is not mandatory for a package's `:licenses` value to contain only SPDX license identifiers, it is only recommended.
  Therefore, some problems reported by `mix licenses` may be false alarms.
  For example, a project may specify its license as `MIT License` rather than the SPDX identifier `MIT`.

  ## Command line options

    * `--osi` - additionally check if all licenses are approved by the [Open Source Initiative](https://opensource.org/licenses)
    * `--update` - pull down a fresh copy of the SPDX license list instead of using the version checked in with this tool.
  """

  use Mix.Task
  alias HexLicenses.Check.{Deprecation, OSIApproval, SPDXListed}
  alias HexLicenses.Check

  @shortdoc "Prints all dependencies with unrecognized or non-OSI-approved licenses."

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

    failures =
      HexLicenses.license_check(checks)
      |> Enum.map(fn {dep, results} ->
        failed_results = Enum.reject(results, &Check.pass?/1)

        {dep, failed_results}
      end)
      |> Enum.reject(fn {_dep, results} -> Enum.empty?(results) end)

    if Enum.empty?(failures) do
      IO.puts("All checks passed, nothing to explain.")
    else
      Enum.each(failures, fn {dep, results} ->
        failure_messages = Enum.flat_map(results, &Check.list_failures/1)

        shell = Mix.shell()

        shell.info("#{dep}'s licenses have #{Enum.count(failure_messages)} problem(s):")

        failure_messages
        |> Enum.map(&"- #{&1}")
        |> Enum.join("\n")
        |> shell.info()
      end)
    end
  end
end
