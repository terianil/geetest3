defmodule Geetest3.Test do
  use ExUnit.Case
  import Tesla.Mock
  doctest Geetest3

  setup do
    mock(fn
      %{method: :get, url: "http://api.geetest.com/register.php?gt=test_id&json_format=1"} ->
        %Tesla.Env{status: 200, body: %{"challenge" => "test_challenge"}}

      %{
        method: :get,
        url:
          "http://api.geetest.com/validate.php?challenge=challenge&json_format=1&seccode=seccode&validate=validate"
      } ->
        %Tesla.Env{status: 200, body: %{"seccode" => "seccode"}}
    end)

    :ok
  end

  test "register success" do
    assert {:ok, "9f2d9acabc7fe4189eb29561acb6f81f"} = Geetest3.register()
  end

  test "validate success" do
    assert {:ok, true} = Geetest3.validate("challenge", "validate", "seccode")
  end
end
