defmodule Fetch.RegexParserTest do
  use ExUnit.Case
  alias Fetch.RegexParser, as: Parser
  doctest Parser

  @image_one "<img src=\"one.png\" alt=\"first beautiful image\"/>"
  @image_two "<img src=\"two.png\" alt=\"second beautiful image\"/>"

  @link_one "<a href=\"http://link1\">link one</a>"
  @link_two "<a href=\"http://link2\">link two</a>"

  test "can i break the thing" do
    assert Fetch.Result.new(nil, nil) == %Fetch.Result{assets: [], links: []}
  end

  test "parses empty string" do
    result = Parser.parse("")

    assert result.assets == []
    assert result.links == []
  end

  test "parses string with one image" do
    page = "<html>#{@image_one}</html>"

    result = Parser.parse(page)

    assert result.assets == [@image_one]
    assert result.links == []
  end

  test "parses string with two images" do
    page = "<html>#{@image_one}#{@image_two}</html>"

    result = Parser.parse(page)

    assert result.assets == [@image_one, @image_two]
    assert result.links == []
  end

  test "parses string with one link" do
    page = "<html>#{@link_one}</html>"

    result = Parser.parse(page)

    assert result.assets == []
    assert result.links == [@link_one]
  end

  test "parses string with two links" do
    page = "<html>#{@link_one}#{@link_two}</html>"

    result = Parser.parse(page)

    assert result.assets == []
    assert result.links == [@link_one, @link_two]
  end

  test "parses string with multiple images and links" do
    page = "<html>#{@image_one}#{@image_two}#{@link_one}#{@link_two}</html>"

    result = Parser.parse(page)

    assert result.assets == [@image_one, @image_two]
    assert result.links == [@link_one, @link_two]
  end
end
