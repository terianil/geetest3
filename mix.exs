defmodule Geetest3.MixProject do
  use Mix.Project

  def project do
    [
      app: :geetest3,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/terianil/geetest3"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ibrowse]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:jason, "~> 1.0"},
      {:ibrowse, "~> 4.2"}
    ]
  end

  defp description() do
    "A simple server side implementation of GeeTest v3 captcha."
  end

  defp package() do
    [
      name: "geetest3",
      files: ~w(lib .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/terianil/geetest3"}
    ]
  end
end
