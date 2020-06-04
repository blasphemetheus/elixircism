defmodule RunLengthEncoder do
  @numbers String.graphemes("1234567890")
  @pOSTFIX_JUNK "|"
  @pREFIX_JUNK "|"
  @starting_accumulator {@pREFIX_JUNK, 0}
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  # Try using Enum.reduce rather than building your own recursion.
  # To encode turn string into grapheme's then iterate.
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    # add postfix 
    {reduced_result, _} = string <> @pOSTFIX_JUNK
    |> String.graphemes()
    |> Enum.map_reduce(
      @starting_accumulator,
      fn prev, {grapheme, count} -> 
        {reduce_current(prev, grapheme, count), pass_as_accumulator(prev, grapheme, count)}
      end)
    Enum.filter(reduced_result, fn x -> x != nil end)
    |> to_string()
  end
  
  defp reduce_current(previous, grapheme, count) do
    cond do
      count == 0 -> nil
      grapheme != previous and count == 1 -> "#{grapheme}"
      grapheme != previous -> "#{count}#{grapheme}"
      grapheme == previous -> nil
    end
  end

  defp pass_as_accumulator(previous, grapheme, count) do
    cond do
      grapheme == previous -> {grapheme, count + 1}
      grapheme != previous -> {previous, 1}
    end
  end

  #-----------------------------------------------------------------------------

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    String.graphemes(string)
    |> parse_for_numbers_decode()
    |> to_string()
  end

  @spec parse_for_numbers_decode(list :: list(String.t())) :: list(list(String.t()))
  def parse_for_numbers_decode(list) do
    case list do
      [] -> []
      [last] -> [last]
      [current | rest] ->
        if String.contains?(current, @numbers) do
          deal_with_numbers_decode(current, rest)
        else
          [current] ++ parse_for_numbers_decode(rest)
        end
    end
  end

  @spec deal_with_numbers_decode(previous_number :: String.t(), list :: list(String.t())) :: list(list(String.t()))
  def deal_with_numbers_decode(previous_number, list) do
    case list do
      [] -> :error
      [last] -> [String.duplicate(last, String.to_integer(previous_number))]
      [current | rest] ->
        if String.contains?(current, @numbers) do
          deal_with_numbers_decode(previous_number <> current, rest)
        else
          [String.duplicate(current, String.to_integer(previous_number))] ++ parse_for_numbers_decode(rest)
        end
    end
  end
end
