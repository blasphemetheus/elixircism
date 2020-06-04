defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of 
  steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_integer(input) and input > 0, do: run_it(input, 0)

  defp run_it(1, count), do: count

  defp run_it(input, count) do
    cond do 
      is_even?(input) -> Integer.floor_div(input, 2) |> run_it(count + 1)
      true -> input * 3 + 1 |> run_it(count + 1)
    end
  end

  defp is_even?(input), do: Integer.mod(input, 2) == 0

end
