defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    first_line = "#{how_many_bottles(number)} of beer on the wall, #{how_many_bottles(number)} of beer.\n"

    second_line = case number do
      0 -> "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
      1 -> "Take it down and pass it around, #{how_many_bottles(number - 1)} of beer on the wall.\n"
      _ -> "Take one down and pass it around, #{how_many_bottles(number - 1)} of beer on the wall.\n"
    end

    String.capitalize(first_line) <> second_line
  end

  defp how_many_bottles(number) do
    case number do
      0 -> "no more bottles"
      1 -> "1 bottle"
      _ -> "#{number} bottles"
    end
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    Enum.map(range, &verse/1)
    |> Enum.join("\n")
  end
end
