defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by 
  newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    rows = Enum.to_list(0..String.length(input) - 1)

    split_by_row = String.split(input, ~s/\n/) |> Enum.map(&String.split()/1)
    List.zip([rows, split_by_row])
    |> Enum.map(fn {row_index, list_of_row} = rows  ->
      cols = Enum.to_list(0..length(list_of_row) - 1)
      
      custom_zip(row_index, cols, list_of_row)
    end)
    |> List.flatten()
    |> Enum.into(%{})
    # |> Enum.reduce(&(Map.merge(&1, &2, fn _k, v1, v2 -> v1 + v2 end ) ) )
    # |> Enum.into(%{})
  end

  defp custom_zip(row_index, cols, list_of_row) do
    columns = List.zip([cols, list_of_row])
    for column_index <- cols do {{row_index, column_index}, Enum.at(list_of_row, column_index)} end

    # {row_index, cols, list_of_row}
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
    |> Enum.map(fn
      {{row, col}, value} when col == 0 and row != 0-> {{row, col}, "\n" <> value}
      {{row, col}, value} -> {{row, col}, value} 
    end)
    |> Enum.reduce([], fn
      {{_row, 0}, value}, acc -> acc ++ [value]
      {{_row, _col}, value}, acc -> acc ++ [" " <> value]
      end)
    |> Enum.join()

  end

  @doc """
  Given a `matrix`, return its rows as a
  list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    positions_to_values = Map.to_list(matrix)
    positions = Map.keys(matrix)
    biggest_row = positions
    |> Enum.map(fn {row, _col} -> row end)
    |> Enum.max()
    biggest_col = positions
    |> Enum.map(fn {_row, col} -> col end)
    |> Enum.max()
    
    positions_to_val    positions = Map.keys(matrix)
    biggest_row = positions
    |> Enum.map(fn {row, _col} -> row end)
    |> Enum.max()
    biggest_col = positions
    |> Enum.map(fn {_row, col} -> col end)
    |> Enum.max()ues
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
  end

  @doc """
  Given a `matrix`, return its columns as a
  list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
  end

  @doc """
  Given a `matrix` and `index`, return the column at
  `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
  end
end
