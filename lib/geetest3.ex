defmodule Geetest3 do
  @moduledoc """
  Documentation for `Geetest3`.
  """
  require Logger

  defp config(), do: Application.fetch_env!(:geetest3, :config)

  @doc """
  Register captcha.

  ## Examples

      iex> Geetest3.register()
      %{
        challenge: "9f2d9acabc7fe4189eb29561acb6f81f",
        gt: "test_id",
        new_captcha: true,
        offline: false
      }

  """
  @spec register :: %{challenge: binary, gt: binary, new_captcha: true, offline: boolean}
  def register() do
    config = config()

    case Geetest3.Client.get("/register.php?gt=#{config[:id]}&json_format=1") do
      {:ok, %Tesla.Env{status: status} = response} when status in 200..299 ->
        challenge =
          (response.body["challenge"] <> config[:key])
          |> hash

        %{
          gt: config[:id],
          challenge: challenge,
          offline: false,
          new_captcha: true
        }

      error ->
        Logger.warn("#{__MODULE__}: register error: #{inspect(error)}")

        rnd1 = Enum.random(0..99) |> Integer.to_string() |> hash()
        rnd2 = Enum.random(0..99) |> Integer.to_string() |> hash() |> String.slice(0, 2)
        challenge = "#{rnd1}#{rnd2}"

        %{
          gt: config[:id],
          challenge: challenge,
          offline: true,
          new_captcha: true
        }
    end
  end

  @doc """
  Validate captcha.

  ## Examples

      iex> Geetest3.validate("challenge", "validate", "seccode")
      {:ok, true}

  """
  @spec validate(binary, binary, binary) :: {:error, Tesla.Env.t()} | {:ok, boolean}
  def validate(challenge, validate, seccode) do
    case Geetest3.Client.post(
           "/validate.php?seccode=#{seccode}&challenge=#{challenge}&validate=#{validate}&json_format=1",
           ""
         ) do
      {:ok, %Tesla.Env{status: status} = response} when status in 200..299 ->
        {:ok, response.body["seccode"] == hash(seccode)}

      {:ok, %Tesla.Env{} = response} ->
        {:error, response}

      {:error, %Tesla.Env{} = error} ->
        {:error, error}
    end
  end

  @doc """
  Validate failback captcha.

  ## Examples

      iex> Geetest3.validate_failback("challenge", "validate", "seccode")
      {:ok, false}

  """
  @spec validate_failback(binary, binary, binary) :: {:ok, boolean}
  def validate_failback(challenge, validate, _seccode) do
    {:ok, hash(challenge) == validate}
  end

  defp hash(source) do
    :crypto.hash(:md5, source)
    |> Base.encode16(case: :lower)
  end
end
