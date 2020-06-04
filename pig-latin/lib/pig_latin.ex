defmodule PigLatin do
  @consonant_collection ["v", "h","f", "t", "d", "g", "k", "c", "m", "b", "n", "l", "p", "w", "q","s","z", "x", "y", "r"]
  @vowel_collection ["a", "e", "i", "o", "u"]
  @consonants_treated_as_vowels_if_before_consonant ["y", "x"]
  @q "q"
  @vowels_treated_as_consonants_if_following_q ["u"]

  @pig_latin_signifier "ay"
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    chunked_by_word = String.split(phrase)
    # now its all the words in a list ie ["all", "them", "words"]
    default_prefix = ""
    Enum.map(chunked_by_word, fn word -> translate_one_word(default_prefix, word) end)
    |> Enum.join(" ")
  end

  @spec translate_one_word(prefix :: String.t(), raw_word :: String.t()) :: String.t()
  defp translate_one_word(prefix, raw_word) do
    cond do
      begins_with?(raw_word, @vowel_collection) ->
        cond do
          begins_with?(raw_word, @vowels_treated_as_consonants_if_following_q) and String.length(prefix) > 0 and String.last(prefix) == @q ->
            {accumulating_prefix, rest_of_word} = String.split_at(raw_word, 1)
            new_prefix = prefix <> accumulating_prefix
            translate_one_word(new_prefix, rest_of_word)
          true ->
            new_finished_word = raw_word <> prefix
            append_signifier(new_finished_word)
          end
      begins_with?(raw_word, @consonant_collection) ->
        cond do
          String.length(prefix) > 0 and String.last(prefix) in @consonants_treated_as_vowels_if_before_consonant ->
            {most_of_prefix, last_special_in_prefix} = String.split_at(prefix, -1)
            append_signifier(last_special_in_prefix<>raw_word<> most_of_prefix)
          true ->
            {accumulating_prefix, rest_of_word} = String.split_at(raw_word, 1)
            new_prefix = prefix <> accumulating_prefix
            translate_one_word(new_prefix, rest_of_word)
        end
    end
  end

  @spec begins_with?(string :: String.t(), prefix :: list(String.t())) :: boolean
  defp begins_with?(string, prefix) do
    String.ends_with?(String.reverse(string), Enum.map(prefix, fn x -> String.reverse(x) end))
  end

  @spec append_signifier(word :: String.t()) :: String.t()
  defp append_signifier(word) do
    word <> @pig_latin_signifier
  end

end
