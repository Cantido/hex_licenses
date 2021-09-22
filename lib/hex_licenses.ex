# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses do
  @moduledoc """
  Documentation for `HexLicenses`.
  """

  alias HexLicenses.Hex

  def lint(package, license_list) do
    if is_nil(package) do
      {:error, :package_not_defined}
    else
      results =
        Map.new(package[:licenses], fn license ->
          {license, license_status(license, license_list)}
        end)

      {:ok, results}
    end
  end

  def license_check(spdx_licenses) when is_map(spdx_licenses) do
    app_deps()
    |> Task.async_stream(fn dep ->
      licenses = Hex.license_for_package(to_string(dep))
      {dep, licenses}
    end)
    |> Stream.map(fn {:ok, val} -> val end)
    |> Enum.map(fn
      {dep, {:ok, licenses}} ->
        license_statuses =
          Map.new(licenses, fn license ->
            {license, license_status(license, spdx_licenses)}
          end)

        {dep, license_statuses}

      {dep, {:error, :enoent}} ->
        {dep, :not_in_hex}
    end)
    |> Map.new()
  end

  def license_status(license, license_map) when is_map(license_map) do
    cond do
      not Map.has_key?(license_map, license) -> :not_recognized
      license_map[license].deprecated? -> :deprecated
      license_map[license].osi_approved? -> :osi_approved
      true -> :not_approved
    end
  end

  defp app_deps do
    Mix.Project.get!().project()[:deps] |> Enum.map(&elem(&1, 0))
  end
end
