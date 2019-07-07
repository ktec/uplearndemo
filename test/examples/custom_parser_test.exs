defmodule CustomParserTest do
  use ExUnit.Case
  alias CustomParser, as: Parser

  @tag :examples
  test "returns the first tag" do
    assert Parser.parse("<html><body></body></html>") == %{first: "<html>"}
  end
end
