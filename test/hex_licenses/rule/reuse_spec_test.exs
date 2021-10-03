# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.Rule.ReuseSpecTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Rule.ReuseSpec
  alias HexLicenses.Rule
  doctest ReuseSpec

  test "does not pass if a license is in the mixfile but not in the LICENSES dir" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Rule.results(["IN-BOTH", "IN-MIX"])

    refute Rule.pass?(results)
  end

  test "does not pass if a license is in the LICENSES dir but not in the mixfile" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH", "IN-DIRECTORY"]))
      |> Rule.results(["IN-BOTH"])

    refute Rule.pass?(results)
  end

  test "passes if licenses are all listed" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Rule.results(["IN-BOTH"])

    assert Rule.pass?(results)
  end

  test "returns summary if a license is in the mixfile but not in the LICENSES dir" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Rule.results(["IN-BOTH", "IN-MIX"])

    assert Rule.failure_summary(results) == "1 unmatched"
  end

  test "returns summary if a license is in the LICENSES dir but not in the mixfile" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH", "IN-DIRECTORY"]))
      |> Rule.results(["IN-BOTH"])

    assert Rule.failure_summary(results) == "1 unmatched"
  end

  test "Returns explanation if a license is in the mixfile but not in the LICENSES dir" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Rule.results(["IN-BOTH", "IN-MIX"])

    assert Rule.list_failures(results) == [
             "\"IN-MIX\" is in mix.exs, but not in your LICENSES/ directory."
           ]
  end

  test "Returns explanation if a license is in the LICENSES dir but not in the mixfile" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH", "IN-DIRECTORY"]))
      |> Rule.results(["IN-BOTH"])

    assert Rule.list_failures(results) == [
             "\"IN-DIRECTORY\" is in your LICENSES/ directory, but not in mix.exs."
           ]
  end
end
