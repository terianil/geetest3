defmodule Geetest3.Client do
  use Tesla

  adapter(Tesla.Adapter.Ibrowse)

  plug(Tesla.Middleware.BaseUrl, "https://api.geetest.com")
  plug(Tesla.Middleware.JSON)
end
