defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    input
    |> Enum.map(&reverse/1)
    |> Enum.reduce([], &pull_out_from_list/2)
    |> Enum.map(&old_to_new/1)
    |> Enum.reduce(%{}, fn {val, key}, acc -> Map.merge(acc, %{val => key}) end)
  end

  defp reverse({key, val}), do: {val, key}

  defp pull_out_from_list({list, val}, acc) when is_list(list) do
    acc ++ for i <- list, do: {i, val}
  end

  defp old_to_new({old_word, old_val}) do
    {String.downcase(old_word), old_val}
  end
end