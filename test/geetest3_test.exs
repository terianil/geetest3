defmodule Geetest3.Test do
  use ExUnit.Case
  import Tesla.Mock
  doctest Geetest3

  setup do
    mock(fn
      %{method: :get, url: "https://api.geetest.com/register.php?gt=test_id&json_format=1"} ->
        %Tesla.Env{status: 200, body: %{"challenge" => "test_challenge"}}

      %{
        method: :post,
        url:
          "https://api.geetest.com/validate.php?seccode=seccode&challenge=challenge&validate=validate&json_format=1"
      } ->
        %Tesla.Env{status: 200, body: %{"seccode" => "af3ccef54fa323a4d26ecc1584a18d29"}}
    end)

    :ok
  end

  test "register success" do
    assert %{
             challenge: "9f2d9acabc7fe4189eb29561acb6f81f",
             gt: "test_id",
             new_captcha: true,
             offline: false
           } = Geetest3.register()
  end

  test "validate success" do
    assert {:ok, true} = Geetest3.validate("challenge", "validate", "seccode")
  end
end
