defmodule Matrix do
  defstruct matrix: nil

  defguardp starts_col(col) when col == 0
  defguardp not_first_row(row) when row != 0

  @doc """
  Convert an `input` string, with rows separated by 
  newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    k = String.length(input) - 1
    rows = Enum.to_list(0..k)

    split_by_row = String.split(input, ~s/\n/) |> Enum.map(&String.split/1)
    List.zip([rows, split_by_row])
    |> Enum.map(&apply_columns/1)
    |> List.flatten()
    |> Enum.into(%{})
  end

  defp apply_columns({row_index, list_of_rows}) do
    j = length(list_of_rows) - 1
    cols = Enum.to_list(0..j)

    custom_zip(row_index, cols, list_of_rows)
  end

  defp custom_zip(row_index, cols, list_of_row) do    
    for column_index <- cols do
      {{row_index, column_index}, Enum.at(list_of_row, column_index)}
    end
  end

  @doc """
  Write the `matrix` out as a string, with rows
  separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    list_o_tuples = Map.to_list(matrix)

    list_o_tuples
    |> Enum.map(&add_newlines/1)
    |> Enum.reduce([], &add_spaces/2)
    |> Enum.join()
  end

  defp add_newlines({{row, col}, value}) when starts_col(col) and not_first_row(row) do
    {{row, col}, "\n" <> value}
  end
  defp add_newlines({{_row, _col}, _value} = mapping_tuple), do: mapping_tuple

  defp add_spaces({{_row, 0}, value}, acc), do: acc ++ [value]
  defp add_spaces({{_row, _col}, value}, acc), do: acc ++ [" " <> value]

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
    matrix
    |> Map.to_list()
    |> Enum.filter(fn {{row, _col}, _val} = _mapping_tuple -> row == index end)
    |> Enum.map(fn {{_row, _col}, val} -> val end)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Given a `matrix`, return its rows as a
  list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    positions = Map.keys(matrix)
    biggest_row = positions
    |> Enum.map(fn {row, _col} -> row end)
    |> Enum.max()

    for i <- 0 .. biggest_row, do: row(matrix, i)
  end

  @doc """
  Given a `matrix` and `index`, return the column at
  `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    matrix
    |> Map.to_list()
    |> Enum.filter(fn {{_row, col}, _val} -> col == index end)
    |> Enum.map(fn {{_row, _col}, val} -> val end)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Given a `matrix`, return its columns as a
  list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
    positions = Map.keys(matrix)
    biggest_col = positions
    |> Enum.map(fn {_row, col} -> col end)
    |> Enum.max()

    for i <- 0 .. biggest_col, do: column(matrix, i)
  end
end
