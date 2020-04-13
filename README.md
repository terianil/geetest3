# Geetest3

A simple Elixir server side implementation of GeeTest v3 captcha.

## Installation

1. Add geetest3 to your `mix.exs` dependencies

```elixir
  defp deps do
    [
      {:geetest3, "~> 0.1.0"}
    ]
  end
```

2. Add geetest3 config

```elixir
  config :geetest3, :config,
    id: "GEETEST_ID",
    key: "GEETEST_KEY"
```
