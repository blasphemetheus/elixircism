defmodule Prime do
  @first_prime 2
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer

  def nth(1) do
    @first_prime
  end

  def nth(count) when count > 0 do
    nth(count - 1)
    |> next_prime()
  end

  def next_prime(previous) do
    candidate = previous + 1

    if is_prime(candidate) do
      candidate
    else
      next_prime(candidate)
    end
  end

  defp is_prime(num) do
    @first_prime .. (num - 1)
    |> Enum.all?(&(rem(num, &1) != 0))
  end
end
