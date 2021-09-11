# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.Licenses.Lint do
  use Mix.Task

  def run(_args) do
    {:ok, result} = HexLicenses.lint()

    unsafe_licenses = Enum.filter(result, fn {_license, status} -> status != :osi_approved end)

    if Enum.empty?(unsafe_licenses) do
      Mix.shell().info("This project's licenses are all recognized and OSI-approved.")
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


      exit({:shutdown, 1})
    end
  end
end
