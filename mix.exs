defmodule Pipette.Mixfile do
  use Mix.Project

  @url "https://github.com/liquidz/pipette"
  @description """
  new_data = pipette(data, template)
  """

  def project do
    [
      app:          :pipette,
      version:      "0.0.1",
      elixir:       "~> 1.0",
      name:         "R1",
      source_url:   @url,
      description:  @description,
      package:      package,
      deps:         deps
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:mock,    "~> 0.1.1"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc,  "~> 0.8", only: :dev},
      {:junit_formatter, "~> 0.0.2", only: :test},
    ]
  end

  defp package do
    [
      contributors: ["Masashi Iizuka"],
      licenses:     ["MIT"],
      links:        %{"Github" => @url}
    ]
  end
end
