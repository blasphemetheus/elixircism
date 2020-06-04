defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, 
  but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    Enum.filter(candidates, &anagram_of?(&1, base))
  end

  def anagram_of?(base, candidate) do
    if String.downcase(base) != String.downcase(candidate) do
      letter_frequency(String.downcase(base)) == letter_frequency(String.downcase(candidate))    
    end
  end

  def letter_frequency(string) do
    String.graphemes(string)
    |> Enum.group_by(& &1)
    |> Enum.map(fn {letter, list} -> {letter, Enum.count(list)} end)
  end
end
