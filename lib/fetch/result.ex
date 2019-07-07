defmodule Fetch.Result do
  @moduledoc """
  This module provides the data structure returned when calling
  `Fetch.fetch_url/3` which represents the parsed contents of the html
  response for the given url.
  """

  @opaque t() :: %__MODULE__{}

  defstruct assets: [],
            links: []

  def new(assets, links) when is_list(assets) and is_list(links) do
    %__MODULE__{
      assets: assets,
      links: links
    }
  end

  def new(_assets, _links), do: %__MODULE__{}
end
