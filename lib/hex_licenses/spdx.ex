# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.SPDX do
  @moduledoc """
  Functions for fetching and parsing SPDX license lists, including the locally-stored one.
  """

  def fetch_licenses do
    {:ok, _} = HTTPoison.start()

    HTTPoison.get!("https://spdx.org/licenses/licenses.json")
    |> Map.fetch!(:body)
  end

  def parse_licenses(licenses_json) do
    licenses_json
    |> Poison.decode!()
    |> Map.fetch!("licenses")
    |> Map.new(fn license ->
      details = %{
        deprecated?: Map.fetch!(license, "isDeprecatedLicenseId"),
        osi_approved?: Map.fetch!(license, "isOsiApproved")
      }

      {Map.fetch!(license, "licenseId"), details}
    end)
  end

  def licenses_path do
    Application.app_dir(:hex_licenses, "priv/licenses.exs")
  end

  def licenses do
    {data, _bindings} =
      licenses_path()
      |> Code.eval_file()
    data
  end
end
