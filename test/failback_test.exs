defmodule Geetest3.FailbackTest do
  use ExUnit.Case
  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "https://api.geetest.com/register.php?gt=test_id&json_format=1"} ->
        %Tesla.Env{status: 403, body: "403 Forbidden"}
    end)

    :ok
  end

  @tag :capture_log
  test "register failback" do
    assert {:ok,
            %{
              challenge: challenge,
              gt: "test_id",
              new_captcha: true,
              offline: true
            }} = Geetest3.register()

    assert is_binary(challenge)
    assert String.length(challenge) == 34
  end
end
