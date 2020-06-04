defmodule Sublist do
  @type returns :: :equal | :sublist | :superlist | :unequal
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  @spec compare(a ::list, b :: list) :: returns
  def compare(a, b) do
    cond do
      equals?(a, b) -> :equal
      contains?(a, b) -> :superlist
      contains?(b, a) -> :sublist
      true -> :unequal
    end
  end

  def equals?(a, b) do
    a === b
  end

  def contains?(a, b) when length(a) < length(b), do: false
  def contains?([a_1 | a_tl] = a, b) do
    {a_start, a_rest} = Enum.split(a, length(b))
    equals?(a_start, b) or contains?(a_tl, b)
  end
  def contains?([a_last] = a, b) do
    equals?(a, b) or contains?([], b)
  end
  def contains?([],[]), do: true

end
