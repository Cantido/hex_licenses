defmodule Mix.Tasks.Licenses.CheckDeps do
  use Mix.Task

  def run(_args) do
    unsafe_deps =
    HexLicenses.license_check()
    |> Enum.reject(fn {_deps, licenses} -> licenses == :not_in_hex end)
    |> Enum.filter(fn {_dep, licenses} ->
      Enum.any?(licenses, fn {_license, status} -> status != :osi_approved end)
    end)

    Enum.each(unsafe_deps, fn {dep, licenses} ->
      unsafe_licenses =
        Enum.filter(licenses, fn {_license, status} -> status != :osi_approved end)

      Mix.shell().info("#{dep} has #{Enum.count(unsafe_licenses)} unsafe licenses:")

      Enum.each(licenses, fn {license, status} ->
        case status do
          :not_approved -> Mix.shell().info(" - \"#{license}\" is not OSI-approved.")
          :not_recognized -> Mix.shell().info(" - \"#{license}\" is not an SPDX ID.")
        end
      end)
    end)

    if Enum.empty?(unsafe_deps) do
      Mix.shell().info("All dependencies have OSI-approved licenses.")
    else
      exit({:shutdown, 1})
    end
  end
end
