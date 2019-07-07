defmodule Fetch.FakeHttpClientTest do
  use ExUnit.Case
  alias Fetch.FakeHttpClient, as: HttpClient
  doctest HttpClient

  @fake_page """
  <html>
  <body>
  <img src=\"fakepage.png\">
  <a href=\"http://link1\">link one</a>
  </body>
  </html>
  """

  test "returns a fake response" do
    assert HttpClient.request("https://fakepage.com") == {:ok, @fake_page}
  end
end
