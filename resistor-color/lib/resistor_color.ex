defmodule ResistorColor do
  @moduledoc false
    # bad manual way of doing this ...
    # case color do
    #   "black" -> 0
    #   "brown" -> 1
    #   "red" -> 2
    #   "orange" -> 3
    #   "yellow" -> 4
    #   "green" -> 5
    #   "blue" -> 6
    #   "violet" -> 7
    #   "grey" -> 8
    #   "white" -> 9
    # end

    # the solution they were going for is using Enum.find_index(...)
  @spec colors() :: list(String.t())
  def colors do
    ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"]
  end

  @spec code(String.t()) :: integer()
  def code(color) do
    Enum.find_index(colors, fn x -> x == color end)
  end
end
