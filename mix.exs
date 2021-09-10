# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.MixProject do
  use Mix.Project

  def project do
    [
      app: :hex_licenses,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Rosa Richter"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Cantido/hex_licenses",
        "sourcehut" => "https://sr.ht/~cosmicrose/hex_licenses"
      }
    ]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 1.8"},
      {:poison, "~> 1.2"},
      {:ex_doc, "~> 0.25", only: [:dev], runtime: false}
    ]
  end
end
