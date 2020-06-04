defmodule RomanNumerals do
  @order_downwards %{"M" => "D", "D" => "C", "C" => "L", "L" => "X", "X" => "V", "V" => "I"}
  # @numeral_from_number %{
  #   1 => "I",
  #   5 => "V",
  #   10 => "X",
  #   50 => "L",
  #   100 => "C",
  #   500 => "D",
  #   1000 => "M"
  # }

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()

  def numeral(number) do
    numeral_acc(number, "")
    |> to_string
  end

  defp one_before(numeral_string) do
    @order_downwards[numeral_string]
  end

  defp two_before(numeral_string) do
    one_before(numeral_string)
    |> one_before
  end

  def numeral_acc(number, acc) when number >= 1000 do
    numeral_acc(number - 1000, acc <> "M")
  end

  def numeral_acc(number, acc) when number >= 900 do
    numeral_acc(number - 900, acc <> two_before("M") <> "M")
  end

  def numeral_acc(number, acc) when number >= 500 do
    numeral_acc(number - 500, acc <> "D")
  end

  def numeral_acc(number, acc) when number >= 400 do
    numeral_acc(number - 400, acc <> one_before("D") <> "D")
  end

  def numeral_acc(number, acc) when number >= 100 do
    numeral_acc(number - 100, acc <> "C")
  end

  def numeral_acc(number, acc) when number >= 90 do
    numeral_acc(number - 90, acc <> two_before("C") <> "C")
  end

  def numeral_acc(number, acc) when number >= 50 do
    numeral_acc(number - 50, acc <> "L")
  end

  def numeral_acc(number, acc) when number >= 40 do
    numeral_acc(number - 40, acc <> one_before("L") <> "L")
  end

  def numeral_acc(number, acc) when number >= 10 do
    numeral_acc(number - 10, acc <> "X")
  end

  def numeral_acc(number, acc) when number >= 9 do
    numeral_acc(number - 9, acc <> two_before("X") <> "X")
  end

  def numeral_acc(number, acc) when number >= 5 do
    numeral_acc(number - 5, acc <> "V")
  end

  def numeral_acc(number, acc) when number >= 4 do
    numeral_acc(number - 4, acc <> one_before("V") <> "V")
  end

  def numeral_acc(number, acc) when number >= 1 do
    numeral_acc(number - 1, acc <> "I")
  end

  def numeral_acc(number, acc) when number == 0 do
    acc
  end
end