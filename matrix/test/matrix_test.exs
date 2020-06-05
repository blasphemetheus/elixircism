defmodule MatrixTest do
  use ExUnit.Case

  @input "1 2 3\n4 5 6\n7 8 9"
  @input_incomplete_line "3 9 1\n0 6 7\n4"
  @matrix_incomplete_line %{
    {0,0} => "3",
    {0,1} => "9",
    {0,2} => "1",
    {1,0} => "0",
    {1,1} => "6",
    {1,2} => "7",
    {2,0} => "4",
}

  test "from_string" do
    assert Matrix.from_string(@input) == %{
      {0,0} => "1",
      {0,1} => "2",
      {0,2} => "3",
      {1,0} => "4",
      {1,1} => "5",
      {1,2} => "6",
      {2,0} => "7",
      {2,1} => "8",
      {2,2} => "9"
    }
    assert Matrix.from_string(@input_incomplete_line) == @matrix_incomplete_line
  end

  test "to_string" do
    assert Matrix.to_string(@matrix_incomplete_line) == @input_incomplete_line
  end

  # @tag :pending
  test "reading from and writing to string" do
    matrix = Matrix.from_string(@input)
    assert Matrix.to_string(matrix) == @input
  end

  # @tag :pending
  test "row should return list at index" do
    matrix = Matrix.from_string(@input)

    assert Matrix.row(matrix, 0) == [1, 2, 3]
    assert Matrix.row(matrix, 1) == [4, 5, 6]
    assert Matrix.row(matrix, 2) == [7, 8, 9]
  end

  # @tag :pending
  test "rows should return nested lists regardless of internal structure" do
    matrix = Matrix.from_string(@input)

    assert Matrix.rows(matrix) == [
             [1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]
           ]
  end

  # @tag :pending
  test "column should return list at index" do
    matrix = Matrix.from_string(@input)

    assert Matrix.column(matrix, 0) == [1, 4, 7]
    assert Matrix.column(matrix, 1) == [2, 5, 8]
    assert Matrix.column(matrix, 2) == [3, 6, 9]
  end

  # @tag :pending
  test "columns should return nested lists regardless of internal structure" do
    matrix = Matrix.from_string(@input)

    assert Matrix.columns(matrix) == [
             [1, 4, 7],
             [2, 5, 8],
             [3, 6, 9]
           ]
  end
end
