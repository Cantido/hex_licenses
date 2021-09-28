defmodule HexLicenses.Check.SPDXListedTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Check.SPDXListed
  alias HexLicenses.Check
  doctest SPDXListed

  test "does not pass if a license is not listed" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Check.results(["LISTED", "UNLISTED"])

    refute Check.pass?(results)
  end

  test "passes if licenses are all listed" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Check.results(["LISTED"])

    assert Check.pass?(results)
  end

  test "formats summary" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Check.results(["UNLISTED"])

    assert Check.failure_summary(results) =~ "1 not recognized"
  end

  test "formats explanation" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Check.results(["UNLISTED"])

    assert Check.list_failures(results) == ["\"UNLISTED\" is not in the SPDX License List"]
  end
end
