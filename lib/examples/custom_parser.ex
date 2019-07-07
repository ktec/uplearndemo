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

  defp extract_first_tag(data) do
    Regex.run(~r/<[^>]*>/, data) |> hd
  end
end
