defmodule HexLicenses.Rule.SPDXListed do
  @enforce_keys [:spdx_data]
  defstruct spdx_data: nil,
            failed_licenses: []

  def new(spdx_data) do
    %__MODULE__{spdx_data: spdx_data}
  end

  defimpl HexLicenses.Rule do
    def results(struct, licenses) do
      failed_licenses = Enum.reject(licenses, &Map.has_key?(struct.spdx_data, &1))

      %{struct | failed_licenses: failed_licenses}
    end

    def pass?(struct), do: Enum.empty?(struct.failed_licenses)

    def failure_summary(struct) do
      count = Enum.count(struct.failed_licenses)

      "#{count} not recognized"
    end

    def list_failures(struct) do
      Enum.map(struct.failed_licenses, fn license ->
        ~s("#{license}" is not in the SPDX License List)
      end)
    end
  end
end
