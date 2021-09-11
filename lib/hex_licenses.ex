# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses do
  @moduledoc """
  Documentation for `HexLicenses`.
  """

  def lint do
    {:ok, _} = HTTPoison.start()
    package = package()
    license_list = spdx_license_list()
    license_osi_approval = Map.new(license_list, &{&1["licenseId"], &1["isOsiApproved"]})

    if is_nil(package) do
      {:error, :package_not_defined}
    else
      results =
        Map.new(package[:licenses], fn license ->
          {license, license_status(license, license_osi_approval)}
        end)

      {:ok, results}
    end
  end

  def license_check do
    {:ok, _} = HTTPoison.start()

    license_list = spdx_license_list()
    license_osi_approval = Map.new(license_list, &{&1["licenseId"], &1["isOsiApproved"]})

    app_deps()
    |> Task.async_stream(fn dep ->
      licenses = license_for_package(to_string(dep))
      {dep, licenses}
    end)
    |> Stream.map(fn {:ok, val} -> val end)
    |> Enum.map(fn
      {dep, {:ok, licenses}} ->
        license_statuses =
          Map.new(licenses, fn license ->
            {license, license_status(license, license_osi_approval)}
          end)

        {dep, license_statuses}

      {dep, {:error, :not_in_hex}} ->
        {dep, :not_in_hex}
    end)
    |> Map.new()
  end

  def license_status(license, license_map) do
    cond do
      not Map.has_key?(license_map, license) -> :not_recognized
      license_map[license] -> :osi_approved
      true -> :not_approved
    end
  end

  defp license_for_package(package_name) do
    resp = HTTPoison.get!("https://hex.pm/api/packages/#{package_name}")

    if resp.status_code == 200 do
      licenses =
        resp.body
        |> Poison.decode!()
        |> Map.fetch!("meta")
        |> Map.fetch!("licenses")

      {:ok, licenses}
    else
      {:error, :not_in_hex}
    end
  end

  defp spdx_license_list do
    HTTPoison.get!("https://spdx.org/licenses/licenses.json")
    |> Map.fetch!(:body)
    |> Poison.decode!()
    |> Map.fetch!("licenses")
  end

  defp app_deps do
    Mix.Project.get!().project()[:deps] |> Enum.map(&elem(&1, 0))
  end

  defp package do
    Mix.Project.get!().project()[:package]
  end
end
