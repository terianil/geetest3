defmodule Geetest3 do
  @moduledoc """
  Documentation for `Geetest3`.
  """

  defp config(), do: Application.fetch_env!(:geetest3, :config)

  @doc """
  Register captcha.

  ## Examples

      iex> Geetest3.register()
      {:ok,  %{
          challenge: "9f2d9acabc7fe4189eb29561acb6f81f",
          gt: "test_id",
          new_captcha: true,
          offline: false
        }
      }

  """
  def register do
    config = config()

    case Geetest3.Client.get("/register.php?gt=#{config[:id]}&json_format=1") do
      {:ok, %Tesla.Env{status: status} = response} when status in 200..299 ->
        challenge =
          (response.body["challenge"] <> config[:key])
          |> hash

        response = %{
          gt: config[:id],
          challenge: challenge,
          offline: false,
          new_captcha: true
        }

        {:ok, response}

      {:ok, %Tesla.Env{} = response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Validate captcha.

  ## Examples

      iex> Geetest3.validate("challenge", "validate", "seccode")
      {:ok, true}

  """
  def validate(challenge, validate, seccode) do
    case Geetest3.Client.post("/validate.php?seccode=#{seccode}&challenge=#{challenge}&validate=#{validate}&json_format=1", "") do
      {:ok, %Tesla.Env{status: status} = response} when status in 200..299 ->
        {:ok, response.body["seccode"] == hash(seccode)}

      {:ok, %Tesla.Env{} = response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end

  defp hash(source) do
    :crypto.hash(:md5, source)
    |> Base.encode16(case: :lower)
  end
end
