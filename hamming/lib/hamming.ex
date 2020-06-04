defmodule Hamming do
  defguard is_different_length(a, b) when length(a) != length(b)
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when is_different_length(strand1, strand2) do
    {:error, "Lists must be the same length"}
  end

  def hamming_distance(strand1, strand2) do
    distance = List.myers_difference(strand1, strand2)
    |> add_up_myers()

    {:ok, distance}
  end

  defp add_up_myers(myers_difference_list) do
    not_eq = 
    fn
      {:eq, _} -> false
      _other -> true
    end

    number_of_del_or_ins =
    fn
      {:del, deleted} -> String.length(to_string(deleted))
      {:ins, inserted} -> String.length(to_string(inserted))
    end

    myers_difference_list
    |> Enum.filter(not_eq)
    |> Enum.map(number_of_del_or_ins)
    |> Enum.sum()
    |> half()
  end

  defp half(value), do: Kernel.round(value / 2)
end
