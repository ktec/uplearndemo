defmodule Fetch.Result do
  @moduledoc """
  This module provides the data structure returned when calling
  `Fetch.fetch_url/3` which represents the parsed contents of the html
  response for the given url.
  """

  @opaque t() :: %__MODULE__{}

  @enforce_keys [:assets, :links]
  defstruct [:assets, :links]

  def new(assets \\ [], links \\ []) do
    %__MODULE__{
      assets: assets,
      links: links
    }
  end
end
