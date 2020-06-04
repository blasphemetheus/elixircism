defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number
  that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..(limit - 1)
    |> Enum.filter(&(multiples_of_any?(&1, factors)))
    |> Enum.reduce(0, &(&1 + &2))
  end

  def multiples_of_any?(number, factors) do
    Enum.any?(factors, &(multiple_of?(&1, number)))
  end

  def multiple_of?(possible_factor, number) do
    rem(number, possible_factor) == 0
  end
end
