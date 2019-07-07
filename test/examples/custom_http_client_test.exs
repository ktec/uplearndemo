defmodule CustomHttpClientTest do
  use ExUnit.Case
  alias CustomHttpClient, as: HttpClient

  @tag :examples
  test "retrieves the contents of erlang homepage" do
    {:ok, data} = HttpClient.request("http://erlang.org")
    assert length(data) > 0
  end
end
