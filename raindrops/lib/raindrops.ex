defmodule Raindrops do
  @three "Pling"
  @five "Plang"
  @seven "Plong"
  @raindrop_map %{3 => @three, 5 => @five, 7 => @seven}

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    factor_list = Enum.map([3, 5, 7], &(produce_raindrop_if_factor(&1, number)))
    |> Enum.filter(&(&1 != nil))
    if factor_list == [], do: to_string(number), else: to_string(factor_list)
  end

  defp produce_raindrop_if_factor(potential_factor, big_number) do
    the_division = big_number / potential_factor
    if float_is_whole_number?(the_division), do: @raindrop_map[potential_factor]
  end

  @spec float_is_whole_number?(float :: float) :: boolean
  defp float_is_whole_number?(float) do
    parsed = Integer.parse(to_string(float))
    case parsed do
      {_, ".0"} -> true
      _ -> false
    end
  end

end
