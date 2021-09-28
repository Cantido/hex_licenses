defprotocol HexLicenses.Check do
  @moduledoc """
  A protocol for objects that check dependency licenses.
  """

  @doc """
  Analyze the license list, and put results into the struct.
  """
  def results(strategy, license_list)

  @doc """
  Returns `true` if the license list passes this check.
  """
  def pass?(strategy)

  @doc """
  Returns a short string describing the failures.
  For example, "1 not approved", or "2 not recognized".
  This will not be called on an object for which `pass?/1` returns `true`.
  """
  def failure_summary(strategy)

  @doc """
  Returns a list of strings, one describing every license that failed the check.
  For example "'MIT License' was not found in the SPDX list" or "'WTFPL' is not OSI-approved".
  This will not be called on an object for which `pass?/1` returns `true`.
  """
  def list_failures(strategy)
end
