# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.Licenses.Lint do
  @moduledoc """
  Check the current project's licenses.

  The Hex administrators recommend setting a package's `:licenses` value to SPDX license identifiers.
  However, this is only a recommendation, and is not enforced in any way.
  This task will enforce the use of SPDX identifiers in your package,
  and will return an error code if the current project is using any unrecognized or non-OSI-approved licenses.

  ## Configuration

    * `:package` - contain a `:licenses` list, which must be a list containing SPDX license identifiers, for example `["MIT"]`

  ## Command line options

    * `--reuse` - additionally check if the licenses declared in `mix.exs` match those in the `LICENSES` directory
      according to the [REUSE specification](https://reuse.software).
    * `--osi` - additionally check if all licenses are approved by the [Open Source Initiative](https://opensource.org/licenses)
    * `--update` - pull down a fresh copy of the SPDX license list instead of using the version checked in with this tool.
  """
  use Mix.Task
  alias HexLicenses.Check.{Deprecation, OSIApproval, ReuseSpec, SPDXListed}
  alias HexLicenses.Check

  @shortdoc "Check the current project's licenses."

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

    checks =
      if "--reuse" in args do
        [ReuseSpec.new(licenses_in_dir()) | checks]
      else
        checks
      end

    {:ok, results} =
      Mix.Project.get!().project()[:package]
      |> validate_package!()
      |> HexLicenses.lint(checks)

    shell = Mix.shell()

    if Enum.all?(results, &Check.pass?/1) do
      shell.info("All checks passed.")
    else
      Enum.each(results, fn result ->
        unless Check.pass?(result) do
          Check.list_failures(result)
          |> Enum.map(&"- #{&1}")
          |> Enum.join("\n")
          |> shell.info()
        end
      end)
    end
  end

  defp validate_package!(package) do
    if is_nil(package) do
      Mix.shell().error("This project does not have :package key defined in mix.exs.")
      exit({:shutdown, 1})
    end

    if Enum.empty?(Keyword.get(package, :licenses, [])) do
      Mix.shell().error("This project's :package config has a nil or empty :licenses list.")
      exit({:shutdown, 1})
    end

    package
  end

  defp licenses_in_dir do
    Mix.Project.config_files()
    |> Enum.find(fn config_file -> Path.basename(config_file) == "mix.exs" end)
    |> Path.dirname()
    |> Path.join("LICENSES")
    |> File.ls!()
    |> Enum.map(fn license_file -> Path.basename(license_file, ".txt") end)
    |> MapSet.new()
  end
end
