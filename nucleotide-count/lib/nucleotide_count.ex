defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide) do
    acc = 0
    count_acc(strand, nucleotide, acc)
  end

  @spec match(char(), char()) :: boolean()
  def match(nucleotide, characterInQuestion) do
    case characterInQuestion do
      ^nucleotide -> true
      _ -> false
    end
  end

  @spec count_acc(charlist(), char(), non_neg_integer()) :: non_neg_integer()
  def count_acc(strand, nucleotide, acc) do
    case strand do
      [] -> acc
      [head | tail] ->
        case match(nucleotide, head) do
          true -> count_acc(tail, nucleotide, acc + 1)
          false -> count_acc(tail, nucleotide, acc)
        end
    end
  end

  @doc """
  Returns a summary of counts by nucleotide.

  (could just do it by throwing counts of specific characters at it)

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand) do
      %{
        ?A => count(strand, ?A),
        ?T => count(strand, ?T),
        ?C => count(strand, ?C),
        ?G => count(strand, ?G)
        }
  end

end
