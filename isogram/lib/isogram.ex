defmodule Isogram do
  @hyphen "-"
  @space " "
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    String.downcase(sentence)
    |> count_instances()
  end

  defp count_instances(sentence) do
    String.graphemes(sentence)
    |> Enum.filter(&(&1 != @hyphen and &1 != @space))
    |> Enum.reduce(%{}, fn grapheme, acc -> Map.merge(acc, %{grapheme => 1},fn _k, v1, v2 -> v1 + v2 end) end)
    |> Enum.all?(fn {_, count} -> count == 1 end)  
  end
end
