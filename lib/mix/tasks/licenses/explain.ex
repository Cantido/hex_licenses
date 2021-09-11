# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.Licenses.Explain do
  @moduledoc """
  Show dependency licenses that may be unsafe.
  """

  use Mix.Task

  @shortdoc "Show dependency licenses that may be unsafe."

  def run(_args) do
    unsafe_deps =
      HexLicenses.license_check()
      |> Enum.reject(fn {_deps, licenses} -> licenses == :not_in_hex end)
      |> Enum.filter(fn {_dep, licenses} ->
        Enum.any?(licenses, fn {_license, status} -> status != :osi_approved end)
      end)

    Enum.sort_by(unsafe_deps, fn {dep, _licenses} -> to_string(dep) end)
    |> Enum.each(fn {dep, licenses} ->
      unsafe_licenses =
        Enum.filter(licenses, fn {_license, status} -> status != :osi_approved end)

      Mix.shell().info("#{dep} has #{Enum.count(unsafe_licenses)} unsafe licenses:")

      Enum.each(licenses, fn {license, status} ->
        Mix.shell().info(status_line(status))
      end)
    end)

    if Enum.empty?(unsafe_deps) do
      Mix.shell().info("All dependencies have OSI-approved licenses.")
    else
      exit({:shutdown, 1})
    end
  end

  def status_line(:not_approved) do
    " - \"#{license}\" is not OSI-approved."
  end

  def status_line(:not_recognized) do
    " - \"#{license}\" is not an SPDX ID."
  end
end
