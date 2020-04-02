use Mix.Config

config :geetest3, :config,
  id: "test_id",
  key: "test_key"

config :tesla, Geetest3.Client, adapter: Tesla.Mock
