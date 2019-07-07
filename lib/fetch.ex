defmodule Fetch do
  @moduledoc """
  Fetch and parse html content
  """

  @default_parser &Fetch.RegexParser.parse/1
  @default_client &Fetch.FakeHttpClient.request/1

  @doc """
  Make a request for the given url, parses the data and return the result.
  """
  def fetch_url(url, opts) do
    http = Keyword.get(opts, :http_client, @default_client)
    parser = Keyword.get(opts, :parser, @default_parser)

    with {:ok, data} <- http.(url) do
      parser.(data)
    end
  end

  @doc """
  Same as fetch_url except the request is handled asynchronously. To retrieve
  the result, the calling process must review its mailbox and wait for a
  message designated with the reference which will contain the response.
  """
  def fetch_url!(url, opts) do
    # add job to queue
    current = self()
    enqueue(current, url, opts)
  end

  def enqueue(pid, url, opts) do
    _child =
      spawn(fn ->
        result = fetch_url(url, opts)
        Process.send_after(pid, {url, result}, 1000)
      end)

    # lets just use url as the ref for now...
    url
  end
end
