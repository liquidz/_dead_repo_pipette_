defmodule Pipette.Mixfile do
  use Mix.Project

  def project do
    [app:          :pipette,
     version:      "0.0.1",
     elixir:       "~> 1.0",
     name:         "pipette",
     source_url:   "https://github.com/liquidz/pipette",
     homepage_url: "https://github.com/liquidz/pipette",
     deps:         deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:mock,    "~> 0.1.1"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc,  "~> 0.8", only: :dev}
    ]
  end
end
