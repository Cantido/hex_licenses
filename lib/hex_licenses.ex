defmodule HexLicenses do
  @moduledoc """
  Documentation for `HexLicenses`.
  """

  def license_check do
    {:ok, _} = HTTPoison.start()

    license_list = spdx_license_list()
    license_osi_approval = Map.new(license_list, &{&1["licenseId"], &1["isOsiApproved"]})

    app_deps()
    |> Map.new(fn dep ->
      licenses = license_for_package(to_string(dep))
      {dep, licenses}
    end)
    |> Enum.map(fn {dep, licenses} ->
      license_statuses =
        Map.new(licenses, fn license ->
          {license, license_status(license, license_osi_approval)}
        end)

      {dep, license_statuses}
    end)
  end

  def license_status(license, license_map) do
    cond do
      not Map.has_key?(license_map, license) -> :not_found
      license_map[license] -> :osi_approved
      true -> :not_approved
    end
  end

  defp license_for_package(package_name) do
    HTTPoison.get!("https://hex.pm/api/packages/#{package_name}")
    |> Map.fetch!(:body)
    |> Poison.decode!()
    |> Map.fetch!("meta")
    |> Map.fetch!("licenses")
  end

  defp spdx_license_list do
    HTTPoison.get!("https://spdx.org/licenses/licenses.json")
    |> Map.fetch!(:body)
    |> Poison.decode!()
    |> Map.fetch!("licenses")
  end

  defp app_deps do
    Mix.Project.get!().project()[:deps] |> Keyword.keys()
  end
end
