defmodule HexLicenses.Check.ReuseSpecTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Check.ReuseSpec
  alias HexLicenses.Check
  doctest ReuseSpec

  test "does not pass if a license is in the mixfile but not in the LICENSES dir" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Check.results(["IN-BOTH", "IN-MIX"])

    refute Check.pass?(results)
  end

  test "does not pass if a license is in the LICENSES dir but not in the mixfile" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH", "IN-DIRECTORY"]))
      |> Check.results(["IN-BOTH"])

    refute Check.pass?(results)
  end

  test "passes if licenses are all listed" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Check.results(["IN-BOTH"])

    assert Check.pass?(results)
  end

  test "returns summary if a license is in the mixfile but not in the LICENSES dir" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Check.results(["IN-BOTH", "IN-MIX"])

    assert Check.failure_summary(results) == "1 unmatched"
  end

  test "returns summary if a license is in the LICENSES dir but not in the mixfile" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH", "IN-DIRECTORY"]))
      |> Check.results(["IN-BOTH"])

    assert Check.failure_summary(results) == "1 unmatched"
  end

  test "Returns explanation if a license is in the mixfile but not in the LICENSES dir" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH"]))
      |> Check.results(["IN-BOTH", "IN-MIX"])

    assert Check.list_failures(results) == [
             "\"IN-MIX\" is in mix.exs, but not in your LICENSES/ directory."
           ]
  end

  test "Returns explanation if a license is in the LICENSES dir but not in the mixfile" do
    results =
      ReuseSpec.new(MapSet.new(["IN-BOTH", "IN-DIRECTORY"]))
      |> Check.results(["IN-BOTH"])

    assert Check.list_failures(results) == [
             "\"IN-DIRECTORY\" is in your LICENSES/ directory, but not in mix.exs."
           ]
  end
end
