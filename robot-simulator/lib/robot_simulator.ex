defmodule RobotSimulator do
  defguard invalid_direction(value) when value not in [:north, :east, :south, :west]
  defguard wrong_size_tuple(value) when tuple_size(value) != 2
  defguard elements_not_integers(value) when not is_integer(elem(value, 1)) or not is_integer(elem(value, 0))
  defguard invalid_position(value) when not is_tuple(value) or wrong_size_tuple(value) or elements_not_integers(value)

  defstruct direction: :north, position: {0, 0}
  @type directions :: :north | :east | :south | :west
  @type instructions :: :right | :left | :advance

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(dir \\ :north, pos \\ {0, 0})
  def create(dir, _pos) when invalid_direction(dir) do
    {:error, "invalid direction"}
  end

  def create(_dir, pos) when invalid_position(pos) do
    {:error, "invalid position"}
  end

  def create(direction, position) do
    %__MODULE__{direction: direction, position: position}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    do_simulate(robot, String.graphemes(instructions))
  end

  defp do_simulate(%__MODULE__{direction: direction, position: position}, ["L" | other_instructions]) do
    %__MODULE__{direction: turn_left(direction), position: position}
    |> do_simulate(other_instructions)
  end

  defp do_simulate(%__MODULE__{direction: direction, position: position}, ["R" | other_instructions]) do
    %__MODULE__{direction: turn_right(direction), position: position}
    |> do_simulate(other_instructions)
  end

  defp do_simulate(%__MODULE__{direction: direction, position: position}, ["A" | other_instructions]) do
    %__MODULE__{direction: direction, position: advance(direction, position)}
    |> do_simulate(other_instructions)
  end

  defp do_simulate(_robot, [_ | _]) do
    {:error, "invalid instruction"}
  end

  defp do_simulate(robot, []), do: robot

  def turn_right(:west), do: :north
  def turn_right(:north), do: :east
  def turn_right(:east), do: :south
  def turn_right(:south), do: :west

  def turn_left(:west), do: :south
  def turn_left(:south), do: :east
  def turn_left(:east), do: :north
  def turn_left(:north), do: :west

  def advance(:north, {x, y}), do: {x, y + 1}
  def advance(:west, {x, y}), do: {x - 1, y}
  def advance(:south, {x, y}), do: {x, y - 1}
  def advance(:east, {x, y}), do: {x + 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position

end