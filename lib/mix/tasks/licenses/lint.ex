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

  @shortdoc "Check the current project's licenses."

  def run(args) do
    package = Mix.Project.get!().project()[:package]

    if is_nil(package) do
      Mix.shell().error("This project does not have :package key defined in mix.exs.")
      exit({:shutdown, 1})
    end

    if Enum.empty?(Keyword.get(package, :licenses, [])) do
      Mix.shell().error("This project's :package config has a nil or empty :licenses list.")
      exit({:shutdown, 1})
    end

    license_list =
      if "--update" in args do
        HexLicenses.SPDX.fetch_licenses()
        |> HexLicenses.SPDX.parse_licenses()
      else
        HexLicenses.SPDX.licenses()
      end

    {:ok, result} = HexLicenses.lint(package, license_list)

    error? = false

    error? =
      if "--reuse" in args do
        check_reuse_spec() || error?
      else
        error?
      end

    check_osi_approved = "--osi" in args

    allowed_statuses =
      if check_osi_approved do
        [:osi_approved]
      else
        [:osi_approved, :not_approved]
      end

    unsafe_licenses =
      Enum.filter(result, fn {_license, status} -> status not in allowed_statuses end)

    error? =
      if Enum.empty?(unsafe_licenses) do
        if check_osi_approved do
          Mix.shell().info("This project's licenses are all recognized and OSI-approved.")
        else
          Mix.shell().info("This project's licenses are all valid SPDX identifiers.")
        end

        error?
      else
        Mix.shell().info("This project has #{Enum.count(unsafe_licenses)} unsafe licenses:")

        Enum.each(unsafe_licenses, &print_status/1)

        true
      end

    if error? do
      exit({:shutdown, 1})
    end
  end

  defp print_status({license, :not_approved}) do
    Mix.shell().info(" - \"#{license}\" is not OSI-approved.")
  end

  defp print_status({license, :not_recognized}) do
    Mix.shell().info(" - \"#{license}\" is not an SPDX ID")
  end

  defp check_reuse_spec do
    mix_licenses =
      Mix.Project.config()
      |> Access.fetch!(:package)
      |> Access.fetch!(:licenses)
      |> MapSet.new()

    file_licenses =
      Mix.Project.config_files()
      |> Enum.find(fn config_file -> Path.basename(config_file) == "mix.exs" end)
      |> Path.dirname()
      |> Path.join("LICENSES")
      |> File.ls!()
      |> Enum.map(fn license_file -> Path.basename(license_file, ".txt") end)
      |> MapSet.new()

    missing_from_mix = MapSet.difference(file_licenses, mix_licenses)
    missing_from_dir = MapSet.difference(mix_licenses, file_licenses)

    if Enum.any?(missing_from_mix) do
      Mix.shell().info("This project has licenses in LICENSES/ that are not declared in mix.exs:")

      Enum.each(missing_from_mix, fn license ->
        Mix.shell().info(" - #{license}")
      end)
    end

    if Enum.any?(missing_from_dir) do
      Mix.shell().info(
        "This project has licenses declared in mix.exs that are not present in LICENSES/"
      )

      Enum.each(missing_from_dir, fn license ->
        Mix.shell().info(" - #{license}")
      end)
    end

    if Enum.empty?(missing_from_mix) and Enum.empty?(missing_from_dir) do
      Mix.shell().info(
        "This project's declared licenses match the files in the LICENSES/ directory"
      )

      false
    else
      true
    end
  end
end
