defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    result = rec_search(numbers, key)

    cond do
      result == :not_found -> :not_found
      true -> {:ok, result}
    end
  end

  def rec_search({}, _key) do
    :not_found
  end

  def rec_search({only} = numbers, key) when tuple_size(numbers) == 1 do
    cond do
      key == only -> 0
      true -> :not_found
    end
  end

  def rec_search(numbers, key) do
    mid_point_idx = tuple_size(numbers) / 2 |> floor()
    mid_point_val = elem(numbers, mid_point_idx)

    cond do
      mid_point_val == key -> mid_point_idx
      mid_point_val < key -> search_in_sub_array(numbers, key, mid_point_idx .. (tuple_size(numbers) - 1))
      mid_point_val > key -> search_in_sub_array(numbers, key, 0 .. (mid_point_idx - 1))
    end
  end

  defp search_in_sub_array(numbers, key, new_array_start .. _new_array_end = new_array) do
    new_array
    |> elems_from(numbers)
    |> List.to_tuple()
    |> rec_search(key)
    |> pass_up_result(new_array_start)
  end

  defp pass_up_result(:not_found, _), do: :not_found
  defp pass_up_result(result, new_array_start), do: result + new_array_start

  defp elems_from(first .. first, tuple) do
    [elem(tuple, first)]
  end

  defp elems_from(range, tuple) do
    for i <- range, do: elem(tuple, i)
  end
end
