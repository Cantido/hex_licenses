defmodule HexLicenses.Rule.DeprecationTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Rule.Deprecation
  alias HexLicenses.Rule
  doctest Deprecation

  test "does not pass if a license is deprecated" do
    results =
      Deprecation.new(%{"OLD" => %{deprecated?: true}})
      |> Rule.results(["OLD", "NEW"])

    refute Rule.pass?(results)
  end

  test "passes if licenses are not deprecated" do
    results =
      Deprecation.new(%{"NEW" => %{deprecated?: false}})
      |> Rule.results(["NEW", "WEIRD"])

    assert Rule.pass?(results)
  end

  test "formats summary" do
    results =
      Deprecation.new(%{"OLD" => %{deprecated?: true}})
      |> Rule.results(["OLD"])

    assert Rule.failure_summary(results) =~ "1 deprecated"
  end

  test "formats explanation" do
    results =
      Deprecation.new(%{"OLD" => %{deprecated?: true}})
      |> Rule.results(["OLD"])

    assert Rule.list_failures(results) == ["\"OLD\" is deprecated"]
  end
end
