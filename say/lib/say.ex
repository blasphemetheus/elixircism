defmodule Say do
  defguard is_billion(val) when val >= 1_000_000_000
  defguard is_million(val) when val >= 1_000_000
  defguard is_thousand(val) when val >= 1_000
  defguard is_hundred(val) when val >= 100
  defguard is_ty(val) when val >= 20
  defguard is_teen(val) when val >= 10
  defguard is_literal(val) when val >= 1
  defguard is_zero(val) when val == 0
  defguard is_negative(val) when val < 0
  defguard is_too_big(val) when val > 999_999_999_999 or val < -999_999_999_999

  @doc """
  Translate a positive integer into English.
  """
  @spec translate(integer) :: {atom, String.t()}

  def in_english(number) when not is_integer(number) do
    {:error, "not an integer"}
  end

  def in_english(num) when is_integer(number) do
    cond do
      Integer.digits(num) > 12 -> {:error, "number is too large"}
      true -> {:ok, translate(number)}
    end
  end

  def in_english(0) do
    {:ok, "zero"}
  end

  def translate(num) do
    case Integer.digits(num)
      1 -> literal(num)
      2 -> meld_tens(num)
      3 -> meld_hundred(num)
      4 -> "thou"
      5 -> "tenthou"
      6 -> "hundred thou"
      7 -> "mil"
      8 -> "ten mil"
      9 -> "hundred mil"
      10 -> "bil"
      11 -> "ten bil"
      12 -> "hundred bil"
    end
  end
  
  def translate(number) when is_negative(number), do: "negative " <> translate(number * -1)
  def translate(number) when is_billion(number), do: meld_billion(number)
  def translate(number) when is_million(number), do: meld_million(number)
  def translate(number) when is_thousand(number), do: meld_thousand(number)
  def translate(number) when is_hundred(number), do: meld_hundred(number)
  def translate(number) when is_ty(number), do: meld_ty(number)
  def translate(number) when is_teen(number), do: meld_teen(number)
  def translate(number) when is_literal(number), do: literal(number)

  defp digit_at_place(num, place), do: Integer.digits(num) |> List.reverse() |> List.at(place)

  defp zeros_place(num), do: digit_at_place(num, 0)
  defp tens_place(num), do: digit_at_place(num, 1)
  defp hundreds_place(num), do: digit_at_place(num, 2)
  defp thousands_place(num), do: digit_at_place(num, 3)
  defp ten_thousands_place(num), do: digit_at_place(num, 4)
  defp hundred_thousands_place(num), do: digit_at_place(num, 5)
  defp millions_place(num), do: digit_at_place(num, 6)
  defp ten_millions_place(num), do: digit_at_place(num, 7)
  defp hundred_millions_place(num), do: digit_at_place(num, 8)
  defp billions_place(num), do: digit_at_place(num, 9)
  defp ten_billions_place(num), do: digit_at_place(num, 10)
  defp hundred_billions_place(num), do: digit_at_place(num, 11)


  defp zero_in_ones_place?(num), do: zeros_place(num) == 0
  defp zero_in_tens_place?(num), do: tens_place(num) == 0
  defp zero_in_hundreds_place?(num), do: hundreds_place(num) == 0
  defp zero_in_thousands_place?(num), do: thousands_place(num) == 0
  defp zero_in_ten_thousands_place?(num), do: ten_thousands_place(num) == 0
  defp zero_in_hundred_thousands_place?(num), do: hundred_thousands_place(num) == 0
  defp zero_in_millions_place?(num), do: millions_place(num) == 0
  defp zero_in_ten_millions_place?(num), do: ten_millions_place(num) == 0
  defp zero_in_hundred_millions_place?(num), do: hundred_millions_place(num) == 0
  defp zero_in_billions_place?(num), do: billions_place(num) == 0
  defp zero_in_ten_billions_place?(num), do: ten_billions_place(num) == 0
  defp zero_in_hundred_billions_place?(num), do: hundred_billions_place(num) == 0

  def literal(0), do: ""
  def literal(1), do: "one"
  def literal(2), do: "two"
  def literal(3), do: "three"
  def literal(4), do: "four"
  def literal(5), do: "five"
  def literal(6), do: "six"
  def literal(7), do: "seven"
  def literal(8), do: "eight"
  def literal(9), do: "nine"

  defp meld_tens(10), do: "ten"
  defp meld_tens(11), do: "eleven"
  defp meld_tens(12), do: "twelve"
  defp meld_tens(13), do: "thirteen"
  defp meld_tens(15), do: "fifteen"
  defp meld_tens(18), do: "eighteen"
  defp meld_tens(num) when is_teen(num), do: translate(num - 10) <> "teen"

  # defp biggest_tens_place(number) do
  # end

  defp meld_ty(90), do: "ninety"
  defp meld_ty(num) when num > 90, do: translate(90) <> "-" <> translate(num - 90)
  defp meld_ty(80), do: "eighty"
  defp meld_ty(num) when num > 80, do: translate(80) <> "-" <> translate(num - 80)
  defp meld_ty(70), do: "seventy"
  defp meld_ty(num) when num > 70, do: translate(70) <> "-" <> translate(num - 70)
  defp meld_ty(60), do: "sixty"
  defp meld_ty(num) when num > 60, do: translate(60) <> "-" <> translate(num - 60)
  defp meld_ty(50), do: "fifty"
  defp meld_ty(num) when num > 50, do: translate(50) <> "-" <> translate(num - 50)
  defp meld_ty(40), do: "forty"
  defp meld_ty(num) when num > 40, do: translate(40) <> "-" <> translate(num - 40)
  defp meld_ty(30), do: "thirty"
  defp meld_ty(num) when num > 30, do: translate(30) <> "-" <> translate(num - 30)
  defp meld_ty(20), do: "twenty"
  defp meld_ty(num) when num > 20, do: translate(20) <> "-" <> translate(num - 20)  

  defp meld_hundred(num) do
    if zero_in_ones_place?(num) and zero_in_tens_place?(num) do
      hundreds_place(num) <> " " <> "hundred"
    else
      translate(hundreds_place(num) * 100) <> " " <> translate(just_below_hundreds(num))
    end
  end

  defp meld_thousand(num) do
    if zero_in_ones_place?() and zero_in_tens_place?() and zero_in_hundreds_place?() do
      thousands_place(num) <> " " <> "thousand"
    else
      translate(thousands_place(num) * 1_000) <> " " <> translate(just_below_thousands(num))
    end
  end

  defp meld_ten(num) do
    if zero_in_ones_place?() and zero_in_tens_place?() and zero_in_hundreds_place?() do
      "big ten-thousandsNumber"
    else
      translate(ten_thousands_place(num) * 10_000) <> " " <> translate(just_below_ten_thousands(num))
    end
  end

  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""
  defp meld_million(1), do: ""

  defp meld_billion(1_000_000_000), do: "billion"
  defp meld_billion(number), do: translate(number - 1_000_000_000) <> meld_billion(1_000_000_000)



end
