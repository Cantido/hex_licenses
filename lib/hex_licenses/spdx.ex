defmodule HexLicenses.SPDX do
  def fetch_licenses do
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

  def licenses do
    {data, _bindings} = Code.eval_file("priv/licenses.exs")
    data
  end
end
