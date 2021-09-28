defmodule HexLicenses.Rule.SPDXListedTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Rule.SPDXListed
  alias HexLicenses.Rule
  doctest SPDXListed

  test "does not pass if a license is not listed" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Rule.results(["LISTED", "UNLISTED"])

    refute Rule.pass?(results)
  end

  test "passes if licenses are all listed" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Rule.results(["LISTED"])

    assert Rule.pass?(results)
  end

  test "formats summary" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Rule.results(["UNLISTED"])

    assert Rule.failure_summary(results) =~ "1 not recognized"
  end

  test "formats explanation" do
    results =
      SPDXListed.new(%{"LISTED" => %{}})
      |> Rule.results(["UNLISTED"])

    assert Rule.list_failures(results) == ["\"UNLISTED\" is not in the SPDX License List"]
  end
end
