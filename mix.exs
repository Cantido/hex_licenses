# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule HexLicenses.MixProject do
  use Mix.Project

  def project do
    [
      app: :hex_licenses,
      description: "Mix tasks to help you use open-source licenses",
      version: "0.2.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      package: package(),
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
      licenses: ["MIT", "CC-BY-4.0", "CC-BY-3.0", "CC0-1.0"],
      links: %{
        "GitHub" => "https://github.com/Cantido/hex_licenses",
        "sourcehut" => "https://sr.ht/~cosmicrose/hex_licenses",
        "Sponsor" => "https://liberapay.com/rosa"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 1.8"},
      {:poison, "~> 3.0"},
      {:credo, "~> 1.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.25", only: [:dev], runtime: false}
    ]
  end
end
