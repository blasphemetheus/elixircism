defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(1), do: {:ok, 1}
  def square(2), do: {:ok, 2}
  def square(num) when num <= 64 and num >= 1 do
    {:ok, prev} = square(num - 1)

    {:ok, prev * 2}
  end
  def square(num) do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    list_of_squares = for squ <- 1 .. 64, do: square(squ) |> extract()

    {:ok, list_of_squares |> Enum.sum()}
  end

  defp extract({:ok, result}), do: result
end
