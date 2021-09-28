defmodule HexLicenses.Rule.OSIApprovalTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Rule.OSIApproval
  alias HexLicenses.Rule
  doctest OSIApproval

  test "does not pass if a license is not approved" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Rule.results(["APPROVED", "NOT-APPROVED"])

    refute Rule.pass?(results)
  end

  test "passes if licenses are all approved" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Rule.results(["APPROVED"])

    assert Rule.pass?(results)
  end

  test "passes if no licenses are recognized" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Rule.results(["NOT-LISTED"])

    assert Rule.pass?(results)
  end

  test "formats summary" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Rule.results(["NOT-APPROVED"])

    assert Rule.failure_summary(results) =~ "1 not approved"
  end

  test "formats explanation" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Rule.results(["NOT-APPROVED"])

    assert Rule.list_failures(results) == ["\"NOT-APPROVED\" is not OSI-approved"]
  end
end
