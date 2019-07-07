defmodule Fetch.Parser do
  @moduledoc false

  @callback parse(String.t()) :: Fetch.Result.t()
end
