defmodule Geetest3.Client do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://api.geetest.com")
  plug(Tesla.Middleware.JSON)
end
