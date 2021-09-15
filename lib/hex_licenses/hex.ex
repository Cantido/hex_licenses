# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.Hex do
  @moduledoc """
  Functions for working with Hex package data.
  """
  def license_for_package(package_name) do
    with {:ok, metadata} <- metadata(package_name) do
      licenses = List.keyfind(metadata, "licenses", 0) |> elem(1)
      {:ok, licenses}
    end
  end

  def metadata_file(package_name) do
    Mix.Project.deps_path()
    |> Path.join(package_name)
    |> Path.join("hex_metadata.config")
    |> String.to_charlist()
  end

  def metadata(package_name) do
    metadata_file(package_name)
    |> :file.consult()
  end
end
