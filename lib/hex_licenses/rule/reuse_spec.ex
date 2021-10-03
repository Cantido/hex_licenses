# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.Rule.ReuseSpec do
  @enforce_keys [:licenses_in_directory]
  defstruct licenses_in_directory: nil,
            licenses_in_hex: []

  def new(licenses_in_directory) do
    %__MODULE__{licenses_in_directory: MapSet.new(licenses_in_directory)}
  end

  defimpl HexLicenses.Rule do
    def results(struct, licenses_in_hex) do
      %{struct | licenses_in_hex: MapSet.new(licenses_in_hex)}
    end

    def pass?(struct), do: MapSet.equal?(struct.licenses_in_hex, struct.licenses_in_directory)

    def failure_summary(%{licenses_in_hex: hex, licenses_in_directory: dir}) do
      all_licenses = MapSet.union(hex, dir)
      matched_licenses = MapSet.intersection(hex, dir)
      unmatched_licenses = MapSet.difference(all_licenses, matched_licenses)
      "#{Enum.count(unmatched_licenses)} unmatched"
    end

    def list_failures(struct) do
      missing_from_package =
        MapSet.difference(struct.licenses_in_directory, struct.licenses_in_hex)
        |> Enum.map(fn license ->
          ~s("#{license}" is in your LICENSES/ directory, but not in mix.exs.)
        end)

      missing_from_directory =
        MapSet.difference(struct.licenses_in_hex, struct.licenses_in_directory)
        |> Enum.map(fn license ->
          ~s("#{license}" is in mix.exs, but not in your LICENSES/ directory.)
        end)

      missing_from_package ++ missing_from_directory
    end
  end
end
