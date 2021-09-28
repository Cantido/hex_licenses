defmodule HexLicenses.Check.DeprecationTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Check.Deprecation
  alias HexLicenses.Check
  doctest Deprecation

  test "does not pass if a license is deprecated" do
    results =
      Deprecation.new(%{"OLD" => %{deprecated?: true}})
      |> Check.results(["OLD", "NEW"])

    refute Check.pass?(results)
  end

  test "passes if licenses are not deprecated" do
    results =
      Deprecation.new(%{"NEW" => %{deprecated?: false}})
      |> Check.results(["NEW", "WEIRD"])

    assert Check.pass?(results)
  end

  test "formats summary" do
    results =
      Deprecation.new(%{"OLD" => %{deprecated?: true}})
      |> Check.results(["OLD"])

    assert Check.failure_summary(results) =~ "1 deprecated"
  end

  test "formats explanation" do
    results =
      Deprecation.new(%{"OLD" => %{deprecated?: true}})
      |> Check.results(["OLD"])

    assert Check.list_failures(results) == ["\"OLD\" is deprecated"]
  end
end
