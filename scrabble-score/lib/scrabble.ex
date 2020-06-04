defmodule Scrabble do
  @one_value ["A", "E", "I", "O", "U", "L", "N", "R", "S", "T"]
  @two_value ["D", "G"]
  @three_value ["B", "C", "M", "P"]
  @four_value ["F", "H", "V", "W", "Y"]
  @five_value ["K"]
  @eight_value ["J", "X"]
  @ten_value ["Q", "Z"]
  @all_values [{@one_value, 1}, {@two_value, 2}, {@three_value, 3}, {@four_value, 4}, {@five_value, 5}, {@eight_value, 8}, {@ten_value, 10}]
  @values Enum.map(@all_values, fn {letters_of_val, val} -> Enum.map(letters_of_val, &({&1, val})) end) 
    |> Enum.map(&(Enum.into(&1, %{}))) 
    |> Enum.reduce(fn x, acc -> Map.merge(x, acc) end)
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    String.graphemes(word)
    |> Enum.map(&get_value/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce(0, &+/2)
  end

  defp get_value(grapheme) do
    @values[String.upcase(grapheme)]
  end

end
