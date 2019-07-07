defmodule Fetch.ResultTest do
  use ExUnit.Case
  alias Fetch.Result
  doctest Result

  test "new/1 with valid arguments" do
    assert Result.new([1], [2]) == %Result{assets: [1], links: [2]}
  end

  test "new/1 with invalid arguments" do
    assert Result.new(nil, nil) == %Result{assets: [], links: []}
  end
end
