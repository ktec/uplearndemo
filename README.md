# Fetch

Fetch is an application for fetching images and links from a webpage.

When given a url, Fetch will run off and grab the page, and scan through the
html looking for img and link tags. It will then return the result in a handy
struct which can be useful for pattern matching to handle errors gracefully.

Example:

```
iex(1)> result = Fetch.fetch_url("https://fakepage.com")
%Result{
  assets: ["<img src=\"fakepage.png\">"],
  links: ["<a href=\"http://link1\">link one</a>"]
}

iex(2)> case result do
...(2)>   %Result{assets: []} -> "No assets found"
...(2)>   other -> "Found #{length(other.assets)} images"
...(2)> end
"Found 1 images"
```

## Async Fetch

The default behaviour for this library is to block until the response is
received and the response has been parsed, scanned and the result created.
This presents some problems when scaling. Imagine we have 100_000 urls to
process! That would take a long time. This is Erlang after all so the solution
is concurrency!

```
iex(1)> {:ok, fetch_ref} = Fetch.fetch_url!("https://fakepage.com")

%Result{
  assets: ["<img src=\"fakepage.png\">"],
  links: ["<a href=\"http://link1\">link one</a>"]
}
iex(2)> receive do
...(2)>   {fetch_ref, result} -> result
...(2)> after
...(2)>   5000 ->
...(2)>     IO.puts(:stderr, "No response within 5 seconds")
...(2)> end
```

NOTE: The implementation of this async feature is purely for show, and whilst
"it works", it's certainly not a production ready approach to this problem. A
solution using a battle tested pooling such as
[Poolboy](https://github.com/devinus/poolboy), or demand driven solution using a
[GenStage](https://github.com/elixir-lang/gen_stage) implementation would likely
be more appropriate. It's worth noting, `fetch_url/3` shouldn't need to change
to upgrade any of these solutions.


## Tests

Tests can be run using:

```
mix test
```

## Behaviours

In order to make this application extensible the `Parser` and `HttpClient` are
provided as behaviours. In order to implement your own parser or client, you
simple have to implement the required callbacks as shown below:

```
defmodule CustomParser do
  @moduledoc false

  @behaviour Fetch.Parser

  @doc """
  Extract the first tag from the page
  """
  def parse(data) do
    tag = extract_first_tag(data)
    %{first: tag}
  end
end
```

Then your custom parser can be use like this:

```
iex> Fetch.fetch_url("http://example.com/", parser: &CustomParser.parse/1)
%{first: "<html>"}
```

Or for using your own http client:

```
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
      {:ok, body}
    end
  end

  defp get(url) do
    :inets.start
    :ssl.start
    :httpc.request(:get, {url, []}, [], [])
  end
end
```

Then your custom parser can be use like this:

```
iex> Fetch.fetch_url("http://example.com/", http_client: &CustomParser.request/1)
%{first: "<html>"}
```


## Architecture

This application is designed in 3 main parts:

1. Fetch

`Fetch` module encapsulates the main API; `fetch_url/3` and `fetch_url!/3`.

2. HttpClient

`FakeHttpClient` module is an implementation of the `HttpClient` behaviour which
provides a stubbed implementation of an http request.

3. Parser

`RegexParser` module is an implementation of the `Parser` behaviour which
provides a very crude html parsing implementation.

The `Fetch` API supports dependency injection of its collaborators, so parts 2
and 3 can be provided as required. This is used in tests, but would also allow
for providing more performant code, or for altering the behaviour in some way,
for example, additionally extracting all H1 tags. The `Parser` implementation
has full control over what data structure is returned by fetch, so if this
change is made, no further changes to `Fetch` module should be required.

## Challenge

This project is a response to the following technical challenge:

Write a function fetch(url) that fetches the page corresponding to the url and
returns an object that has the following attributes:                                     

- assets - an array of urls present in the <img> tags on the page
- links - an array of urls present in the <a> tags on the page

Assume that the code will run on a server. Assume that this work is a part of a
web app that needs to be built further by multiple development teams and will be
maintained and evolved for several years in the future. In addition to these,
make any assumptions necessary, but list those assumptions explicitly.
