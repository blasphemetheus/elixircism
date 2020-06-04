defmodule WordCount do
  @unaccepted String.graphemes("!@#$%^&*()+=`~[]{}\\|\"':;?/>.<,'")
  @space " "
  @underscore "_"
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    rid_of_punctuation(sentence)
    |> String.downcase()
    |> String.split([@space, @underscore], trim: true)
    |> Enum.reduce(%{}, fn x, acc_map -> Map.update(acc_map, x, 1, &(&1 + 1)) end)
  end

  @spec rid_of_punctuation(big_string :: String.t()) :: String.t()
  defp rid_of_punctuation(big_string) do
    String.graphemes(big_string)
    |> Enum.filter(fn x -> not String.contains?(x, @unaccepted) end)
    |> to_string()
  end

end
