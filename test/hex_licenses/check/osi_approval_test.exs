defmodule HexLicenses.Check.OSIApprovalTest do
  use ExUnit.Case, async: true
  alias HexLicenses.Check.OSIApproval
  alias HexLicenses.Check
  doctest OSIApproval

  test "does not pass if a license is not approved" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Check.results(["APPROVED", "NOT-APPROVED"])

    refute Check.pass?(results)
  end

  test "passes if licenses are all approved" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Check.results(["APPROVED"])

    assert Check.pass?(results)
  end

  test "passes if no licenses are recognized" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Check.results(["NOT-LISTED"])

    assert Check.pass?(results)
  end

  test "formats summary" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Check.results(["NOT-APPROVED"])

    assert Check.failure_summary(results) =~ "1 not approved"
  end

  test "formats explanation" do
    results =
      OSIApproval.new(%{
        "APPROVED" => %{osi_approved?: true},
        "NOT-APPROVED" => %{osi_approved?: false}
      })
      |> Check.results(["NOT-APPROVED"])

    assert Check.list_failures(results) == ["\"NOT-APPROVED\" is not OSI-approved"]
  end
end
