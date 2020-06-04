defmodule Pangram do
  @alphabet "abcdefghijklmnopqrstuvwxyz"
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the 
  alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox 
        jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    String.graphemes(@alphabet)
    |> Enum.map(&(String.contains?(String.downcase(sentence), &1)))
    |> Enum.reduce(&(&1 and &2))
  end
end
