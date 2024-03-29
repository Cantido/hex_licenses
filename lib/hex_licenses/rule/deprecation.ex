# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.Rule.Deprecation do
  @moduledoc """
  A `HexLicenses.Rule` that checks for deprecated licenses.
  """
  @enforce_keys [:spdx_data]
  defstruct spdx_data: nil,
            failed_licenses: []

  def new(spdx_data) do
    %__MODULE__{spdx_data: spdx_data}
  end

  defimpl HexLicenses.Rule do
    def results(struct, licenses) do
      failed_licenses =
        licenses
        # drop unrecognized licenses, let the other check validate that
        |> Enum.filter(fn license ->
          Map.has_key?(struct.spdx_data, license) and struct.spdx_data[license].deprecated?
        end)

      %{struct | failed_licenses: failed_licenses}
    end

    def pass?(struct), do: Enum.empty?(struct.failed_licenses)

    def failure_summary(struct) do
      count = Enum.count(struct.failed_licenses)

      "#{count} deprecated"
    end

    def list_failures(struct) do
      Enum.map(struct.failed_licenses, fn license ->
        ~s("#{license}" is deprecated)
      end)
    end
  end
end
