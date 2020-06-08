defmodule IsbnVerifier do
  @digits ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    cond do
      String.length(isbn) == 10 -> deal_with_no_hyphens(isbn)
      String.length(isbn) == 13 -> deal_with_hyphens(isbn)
      true -> false
    end
  end

  defp deal_with_hyphens(isbn) do
    isbn
    |> String.graphemes()
    |> Enum.reject(&String.equivalent?(&1, "-"))
    |> replace_last_digit?()
    |> valid_numbers?()
  end

  defp deal_with_no_hyphens(isbn) do
    isbn
    |> String.graphemes()
    |> replace_last_digit?()
    |> valid_numbers?()
  end

  defp replace_last_digit?(arg) do
    {[last], rest} = arg |> Enum.reverse() |> Enum.split(1)

    new_last = case last do
      "X" -> "10"
      other -> other
    end

    [new_last | rest]
    |> Enum.reverse()
  end

  defp this_number_valid?(num) do
    num in @digits
  end

  defp valid_numbers?(list_o_string_nums) do
    cond do
      Enum.all?(list_o_string_nums, &this_number_valid?/1) ->
        list_o_string_nums
        |> Enum.map(&String.to_integer/1)
        |> mod_math()

      true -> false
    end
  end

  defp mod_math([x1, x2, x3, x4, x5, x6, x7, x8, x9, x10]) do
    [(x1 * 10), (x2 * 9), (x3 * 8), (x4 * 7), (x5 * 6), (x6 * 5), (x7 * 4), (x8 * 3), (x9 * 2), (x10 * 1)]
    |> Enum.sum()
    |> Integer.mod(11) == 0
  end
end