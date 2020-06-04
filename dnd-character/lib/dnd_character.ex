defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }
  @largest_how_many_dice 3
  @dice_size 6

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  def dice_roll(count) do
    for _ <- 1..count, do: Enum.random(1 .. @dice_size)
  end

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    score - 10
    |> Integer.floor_div(2)
  end

  # roll 4 six-sided die, record sum of largest three dice
  @spec ability :: pos_integer()
  def ability do
    dice_roll(4)
    |> Enum.map(fn x -> {:roll, x} end)
    |> List.keysort(1)
    |> Enum.reverse()
    |> Enum.slice(0 .. @largest_how_many_dice - 1)
    |> Enum.map(fn {:roll, x} -> x end)
    |> Enum.sum()
  end

  #do ability once for each score
  @spec character :: t()
  def character do
    con = ability()
    %DndCharacter{
      strength: ability(),
      dexterity: ability(),
      constitution: con,
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability(),
      hitpoints: 10 + modifier(con)
    }
  end
end
