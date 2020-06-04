defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened
    without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    List.flatten(list)
    |> Enum.reject(&is_nil/1)
  end

  def flatten_recursive(list) do
    case list do
      [] -> []
      [nil | x] -> flatten_recursive(x)
      [a | b] -> flatten_recursive(a) ++ flatten_recursive(b)
      x -> [x]
    end
  end
end
