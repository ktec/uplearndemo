defmodule FetchTest do
  use ExUnit.Case
  alias Fetch.Result

  doctest Fetch

  @example_page """
  <html>
  <body>
    <img src="one.png" />
    <img src="two.png" />
    <a href="link_one_url">Link One</a>
    <a href="link_two_url">Link Two</a>
  </body>
  </html>
  """

  @expected_result %Result{
    assets: [
      "<img src=\"one.png\" />",
      "<img src=\"two.png\" />"
    ],
    links: [
      "<a href=\"link_one_url\">Link One</a>",
      "<a href=\"link_two_url\">Link Two</a>"
    ]
  }

  test "fetch_url/2 returns a Result struct" do
    http_client = fn "http://example.com/" -> {:ok, @example_page} end

    assert Fetch.fetch_url("http://example.com/", http_client: http_client) == @expected_result
  end

  test "fetch_url!/2 returns a reference" do
    http_client = fn "http://example.com/" -> {:ok, @example_page} end

    fetch_ref = Fetch.fetch_url!("http://example.com/", http_client: http_client)

    assert fetch_ref == "http://example.com/"

    result =
      receive do
        {^fetch_ref, result} -> result
      end

    assert result == @expected_result
  end
end
