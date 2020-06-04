defmodule Acronym do
  @upcase_alphabet String.graphemes("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  @lowcase_alphabet String.graphemes("abcdefghijklmnopqrstuvwxyz")
  @splitters [" ", "-"]
  @unwanted "_"
  @default_splitter List.first(@splitters)
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    inject_spaces_between_lower_and_upcase(string)
    |> split_and_remove_unwanted()
    |> String.upcase()
  end

  defp inject_spaces_between_lower_and_upcase(some_string) do
    perform_injection_on_graphemes =
    fn grapheme, prev ->
      if String.contains?(grapheme, @upcase_alphabet) do
        if String.contains?(List.last(prev), @lowcase_alphabet) do
          prev ++ [@default_splitter] ++ [grapheme]
        else
          prev ++ [grapheme]
        end
      else
        prev ++ [grapheme]
      end
    end

    List.foldl(String.graphemes(some_string), [""], perform_injection_on_graphemes)
    |> to_string()
  end

  # removes splitter characters, removes unwanted characters at beginning of words,
  # then reduces words to their beginning character
  @spec split_and_remove_unwanted(String.t()) :: String.t()
  defp split_and_remove_unwanted(some_string) do
    String.split(some_string,@splitters)
    |> Enum.map(&String.next_grapheme/1)
    |> purge_nils()
    |> Enum.map(&rid_of_unwanted/1)
    |> Enum.map(fn {first_grapheme, _} -> first_grapheme end)
    |> to_string()
  end

  # regenerates a list of graphemes leaving out nil values
  @spec purge_nils(list_of_next_graphemes :: list(any)) :: list({String.t(), any})
  defp purge_nils(list_of_next_graphemes) do
    for x <- list_of_next_graphemes, x != nil, do: x
  end

  # skips underscores at the front of words
  @spec rid_of_unwanted(tuple :: {String.t(), any}) :: {String.t(), any}
  defp rid_of_unwanted(tuple) do
    case tuple do
      {@unwanted, rest_of_graphemes} -> String.next_grapheme(rest_of_graphemes)
      {_, _} -> tuple
    end
  end
end
