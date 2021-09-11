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

    * `:package` - must be a list containing SPDX license identifiers, for example `["MIT"]`

  ## Command line options

    * `--reuse` - additionally check if the licenses declared in `mix.exs` match those in the `LICENSES` directory
      according to the [REUSE specification](https://reuse.software).
  """
  use Mix.Task

  @shortdoc "Check the current project's licenses."

  def run(args) do
    {:ok, result} = HexLicenses.lint()

    error? = false

    error? =
    if "--reuse" in args do
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
        Mix.shell().info("This project has licenses declared in mix.exs that are not present in LICENSES/")

        Enum.each(missing_from_dir, fn license ->
          Mix.shell().info(" - #{license}")
        end)
      end

      if Enum.empty?(missing_from_mix) and Enum.empty?(missing_from_dir) do
        Mix.shell().info("This project's declared licenses match the files in the LICENSES/ directory")
        error?
      else
        true
      end
    else
      error?
    end

    unsafe_licenses = Enum.filter(result, fn {_license, status} -> status != :osi_approved end)

    error? =
    if Enum.empty?(unsafe_licenses) do
      Mix.shell().info("This project's licenses are all recognized and OSI-approved.")
      error?
    else
      Mix.shell().info("This project has #{Enum.count(unsafe_licenses)} unsafe licenses:")

      Enum.each(unsafe_licenses, fn {license, status} ->
        case status do
          :not_approved ->
            Mix.shell().info(" - \"#{license}\" is not OSI-approved.")

          :not_recognized ->
            Mix.shell().info(" - \"#{license}\" is not an SPDX ID")
        end
      end)

      true
    end

    if error? do
      exit({:shutdown, 1})
    end
  end
end
