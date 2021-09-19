# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.SPDXTest do
  use ExUnit.Case, async: true
  alias HexLicenses.SPDX
  doctest HexLicenses.SPDX

  test "make sure licenses_path is an absolute path" do
    assert Path.type(SPDX.licenses_path()) == :absolute
  end
end
