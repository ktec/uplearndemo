defmodule Fetch.RegexParser do
  @moduledoc false

  @behaviour Fetch.Parser

  @doc """
  Parses the given string using regular expressions and returns
   - a list of images (assets) and
   - a list of urls (links)
  if found in the string.
  """
  def parse(data) do
    assets = extract_assets(data) || []
    links = extract_links(data) || []

    Fetch.Result.new(assets, links)
  end

  def extract_assets(data) do
    Regex.scan(~r/<img[^>]*>/, data)
    |> List.flatten()
  end

  def extract_links(data) do
    Regex.scan(~r/<a[^>]*>[^\/a>]*<\/a>/, data)
    |> List.flatten()
  end
end
