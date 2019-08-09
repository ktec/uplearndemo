defmodule Fetch.MixProject do
  use Mix.Project

  def project do
    [
      app: :fetch,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      # {:floki, "~> 0.8"}
    ]
  end

  defp releases do
    [
      demo: [
        include_executables_for: [:unix],
        applications: [
          runtime_tools: :permanent,
          inets: :permanent,
          ssl: :permanent
        ]
      ]
    ]
  end
end
