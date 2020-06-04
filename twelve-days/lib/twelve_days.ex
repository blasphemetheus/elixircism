defmodule TwelveDays do
  @which_day %{1 => "first", 2 => "second", 3 => "third", 4 => "fourth", 5 => "fifth", 6 => "sixth", 7 => "seventh", 8 => "eighth", 9 => "ninth", 10 => "tenth", 11 => "eleventh", 12 => "twelfth"}
  @gifts_by_day ["zero", "Partridge in a Pear Tree", "Turtle Doves", "French Hens", "Calling Birds", "Gold Rings", "Geese-a-Laying", "Swans-a-Swimming", "Maids-a-Milking", "Ladies Dancing", "Lords-a-Leaping", "Pipers Piping", "Drummers Drumming"]
  @number_prettified ["zero", "a", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve"]
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{@which_day[number]} day of Christmas my true love gave to me: " <> spit(number)
  end

  defp spit(number) when number == 1 do
    Enum.at(@number_prettified, number) <> " " <> Enum.at(@gifts_by_day, number) <> "."
  end

  defp spit(number) when number == 2 do
    Enum.at(@number_prettified, number) <> " " <> Enum.at(@gifts_by_day, number) <> ", and " <> spit(number - 1)

  end

  defp spit(number) do
    Enum.at(@number_prettified, number) <> " " <> Enum.at(@gifts_by_day, number) <> ", " <> spit(number - 1)
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse .. ending_verse
    |> Enum.map(&(verse(&1)))
    |> Enum.reduce(fn x, acc -> acc <> "\n" <> x end)
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end
end
