defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene
  defguard side_lengths_invalid(a, b, c) when a <= 0 or b <= 0 or c <= 0
  defguard triangle_inequality_invalid(a, b, c) when a + b <= c or a + c <= b or b + c <= a
  defguard equal_sides(a, b, c) when a == b and b == c
  defguard some_sides_equal(a, b, c) when a == b or b == c or a == c

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) when side_lengths_invalid(a, b, c) do
    {:error, "all side lengths must be positive"}
  end

  def kind(a, b, c) when triangle_inequality_invalid(a, b, c) do
    {:error, "side lengths violate triangle inequality"}
  end

  def kind(a, b, c) do
    {:ok, type(a, b, c)}
  end

  defp type(a, b, c) when equal_sides(a, b, c) do
    :equilateral
  end

  defp type(a, b, c) when some_sides_equal(a, b, c) do
    :isosceles
  end

  defp type(_a, _b, _c) do
    :scalene
  end
end
