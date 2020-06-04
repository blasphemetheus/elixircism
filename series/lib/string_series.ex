defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_, k) when k <= 0 do
    []
  end

  def slices(string, k) do 
    n = String.length(string)
    if k > n do [] else
      range_starters = 0 .. n - k
      Enum.map(range_starters, fn x -> x .. x + k - 1 end)
      |> Enum.map(&(String.slice(string, &1)))
    end
  end
end
