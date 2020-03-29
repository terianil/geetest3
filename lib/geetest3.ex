defmodule Geetest3 do
  @moduledoc """
  Documentation for `Geetest3`.
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://api.geetest.com")
  plug(Tesla.Middleware.JSON)

  defp config(), do: Application.fetch_env!(:geetest3, :config)

  @doc """
  Register captcha.

  ## Examples

      iex> Geetest3.register()
      {:ok, "9f2d9acabc7fe4189eb29561acb6f81f"}

  """
  def register do
    config = config()

    case get("/register.php?gt=#{config[:id]}&json_format=1") do
      {:ok, %Tesla.Env{status: status} = response} when status in 200..299 ->
        challenge =
          (response.body["challenge"] <> config[:key])
          |> hash

        {:ok, challenge}

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
    query =
      %{
        "challenge" => challenge,
        "validate" => validate,
        "seccode" => seccode,
        "json_format" => 1
      }
      |> URI.encode_query()

    case get("/validate.php?#{query}") do
      {:ok, %Tesla.Env{status: status} = response} when status in 200..299 ->
        {:ok, hash(response.body["seccode"]) == hash(seccode)}

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
