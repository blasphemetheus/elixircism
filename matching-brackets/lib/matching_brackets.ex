defmodule MatchingBrackets do
  @openers ["(", "[", "{"]
  @closers [")", "]", "}"]
  @brackets @openers ++ @closers
  @doc """
  Checks that all the brackets and braces in the string are 
  matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    String.graphemes(str)
    |> Enum.filter(&tracked_char/1)
    |> next([])
  end

  defp tracked_char(grapheme), do: grapheme in @brackets

  defp partner_of("("), do: ")"
  defp partner_of(")"), do: "("
  defp partner_of("["), do: "]"
  defp partner_of("]"), do: "["
  defp partner_of("{"), do: "}"
  defp partner_of("}"), do: "{"

  defp soft_first([]), do: []
  defp soft_first(list), do: hd(list)

  defp next([], acc), do: Enum.reverse(acc) == []
  defp next([bracket | rest] = graphemes, acc) do
    cond do
      bracket in @openers -> next(rest, [bracket | acc])
      bracket in @closers and soft_first(acc) == partner_of(bracket) -> next(rest, tl(acc))
      bracket in @closers and soft_first(acc) != partner_of(bracket) -> next(rest, [bracket | acc])
    end
  end
end
