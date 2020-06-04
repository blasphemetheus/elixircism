defmodule RotationalCipher do
  @alphabet 'abcdefghijklmnopqrstuvwxyz'
  # capAlphabet is just 'ABCDEF ...' but the whole alphabet
  @capAlphabet Enum.map(@alphabet,
    fn char -> String.capitalize(to_string([char])) end)
  |> List.foldl('', fn x, acc -> acc ++ to_charlist(x) end)
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    to_charlist(text)
    |> rotate_using_charlist(shift)
    |> to_string()
  end

  @spec rotate_using_charlist(text_charlist :: charlist, shift :: integer) :: charlist
  defp rotate_using_charlist(text_charlist, shift) do
    Enum.map(text_charlist,
      fn this_char ->
        cond do
          this_char in ?a..?z -> ?a + apply_shift(this_char, shift, @alphabet)
          this_char in ?A..?Z -> ?A + apply_shift(this_char, shift, @capAlphabet)
          true -> this_char
        end
    end)
  end

  # given a character's codepoint value, produces a new index alphabet-shifted 'right' shift_number of times,
  # (when the index would shift past the length of the alphabet it shifts back to 0 and so on)
  @spec apply_shift(this_char :: char, shift_number :: integer, which_alphabet :: charlist) :: char
  defp apply_shift(this_char, shift_number, which_alphabet) do
    alphabet_index_of_this_char = Enum.find_index(which_alphabet, fn x -> x == this_char end)
    rem(shift_number + alphabet_index_of_this_char, length(which_alphabet))
  end

end
