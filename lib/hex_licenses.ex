defmodule HexLicenses do
  @moduledoc """
  Documentation for `HexLicenses`.
  """

  def direct_dependency_licenses do
    app_deps()
    |> Enum.flat_map(fn dep ->
      license_for_package(to_string(dep))
    end)
    |> Enum.uniq()
  end

  def license_for_package(package_name) do
    {:ok, _} = HTTPoison.start()

    HTTPoison.get!("https://hex.pm/api/packages/#{package_name}")
    |> Map.get(:body)
    |> Poison.decode!()
    |> Map.fetch!("meta")
    |> Map.fetch!("licenses")
  end

  def app_deps do
    Mix.Project.get!().project()[:deps] |> Keyword.keys()
  end
end
