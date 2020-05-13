# Geetest3

A simple Elixir server side implementation of GeeTest v3 captcha.

## Installation

1. Add geetest3 to your `mix.exs` dependencies

```elixir
  defp deps do
    [
      {:geetest3, "~> 0.2.0"}
    ]
  end
```

2. Add geetest3 config

```elixir
  config :geetest3, :config,
    id: "GEETEST_ID",
    key: "GEETEST_KEY"
```

## Usage

Register a captcha
```elixir
  Geetest3.register()
  %{
    challenge: "dd290a212412f86b129c622f278c9c11",
    gt: "test_id",
    new_captcha: true,
    offline: false
  }
```

Captcha validation
```elixir
  Geetest3.validate("challenge", "validate", "seccode")
  {:ok, true}
```

Failback captcha validation (for an `offline` challenge)
```elixir
  Geetest3.validate_failback("challenge", "validate", "seccode")
  {:ok, false}
```
