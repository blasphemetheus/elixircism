defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t(), integer) :: map
  def add(db, name, grade) do
    if db[grade] == nil do
      Map.merge(db, %{grade => [name]})
    else
      Map.merge(db, %{grade => db[grade] ++ [name]})
    end
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t()]
  def grade(db, grade) do
    if db[grade] == nil do
      []
    else
      Map.get(db, grade)
    end
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(map) :: [{integer, [String.t()]}]
  def sort(db) do
    Enum.map(db, fn {grade, list_names} -> {grade, Enum.sort(list_names)}end)
  end
end
