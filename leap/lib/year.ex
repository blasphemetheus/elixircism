defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      unless the year is also evenly divisible by 400
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do 
    cond do
      divisible_by?(year, 400) -> true
      divisible_by?(year, 100) -> false
      divisible_by?(year, 4) -> true
      true -> false
    end
  end

  defp divisible_by?(year, divisor) do
    rem(year, divisor) == 0
  end
end
