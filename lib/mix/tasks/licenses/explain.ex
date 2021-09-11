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
  """

  use Mix.Task

  @shortdoc "Prints all dependencies with unrecognized or non-OSI-approved licenses."

  def run(args) do
    check_osi_approved = "--osi" in args

    allowed_statuses =
      if check_osi_approved do
        [:osi_approved]
      else
        [:osi_approved, :not_approved]
      end

    unsafe_deps =
      HexLicenses.license_check()
      |> Enum.reject(fn {_deps, licenses} -> licenses == :not_in_hex end)
      |> Enum.filter(fn {_dep, licenses} ->
        Enum.any?(licenses, fn {_license, status} ->
          status not in allowed_statuses
        end)
      end)

    Enum.sort_by(unsafe_deps, fn {dep, _licenses} -> to_string(dep) end)
    |> Enum.each(fn {dep, licenses} ->
      unsafe_licenses =
        Enum.filter(licenses, fn {_license, status} -> status not in allowed_statuses end)

      Mix.shell().info("#{dep} has #{Enum.count(unsafe_licenses)} unsafe licenses:")

      Enum.each(licenses, fn {license, status} ->
        Mix.shell().info(status_line(license, status))
      end)
    end)

    if Enum.empty?(unsafe_deps) do
      if check_osi_approved do
        Mix.shell().info("All dependencies have OSI-approved licenses.")
      else
        Mix.shell().info("All dependencies have recognized licenses.")
      end
    else
      exit({:shutdown, 1})
    end
  end

  def status_line(license, :not_approved) do
    " - \"#{license}\" is not OSI-approved."
  end

  def status_line(license, :not_recognized) do
    " - \"#{license}\" is not an SPDX ID."
  end
end
