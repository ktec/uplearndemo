defmodule CustomHttpClient do
  @moduledoc false

  @behaviour Fetch.HttpClient

  @doc """
  Make the request using Erlang built in httpc module
  """
  def request(url) when is_binary(url) do
    url
    |> String.to_charlist()
    |> request()
  end

  def request(url) do
    with {:ok, {{_, 200, _}, _headers, body}} <- get(url) do
      {:ok, String.Chars.to_string(body)}
    end
  end

  defp get(url) do
    :inets.start()
    :ssl.start()
    :httpc.request(:get, {url, []}, [], [])
  end
end
