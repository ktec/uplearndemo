defmodule Fetch.FakeHttpClient do
  @moduledoc false

  @behaviour Fetch.HttpClient

  @fake_page """
  <html>
  <body>
  <img src=\"fakepage.png\">
  <a href=\"http://link1\">link one</a>
  </body>
  </html>
  """

  def request("https://fakepage.com") do
    {:ok, @fake_page}
  end

  def request(_url) do
    # do a real request already!
    {:ok, ""}
  end
end
