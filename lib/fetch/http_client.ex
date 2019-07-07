defmodule Fetch.HttpClient do
  @moduledoc false

  @callback request(String.t()) :: {:ok, String.t()} | term()
end
