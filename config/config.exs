use Mix.Config

config :geetest3, :config,
  id: {:system, "GEETEST3_ID"},
  key: {:system, "GEETEST3_KEY"}

import_config "#{Mix.env()}.exs"
