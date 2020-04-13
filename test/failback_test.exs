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
    assert %{
             challenge: challenge,
             gt: "test_id",
             new_captcha: true,
             offline: true
           } = Geetest3.register()

    assert is_binary(challenge)
    assert String.length(challenge) == 34
  end

  test "validate failback success" do
    assert {:ok, true} =
             Geetest3.validate_failback(
               "challenge",
               "b04ec0ade3d49b4a079f0e207d5e2821",
               "seccode"
             )
  end

  test "validate failback fail" do
    assert {:ok, false} = Geetest3.validate_failback("challenge", "wrong_validate", "seccode")
  end
end
