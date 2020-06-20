defmodule Say do
  defguard is_billion(val) when val >= 1_000_000_000
  defguard is_million(val) when val >= 1_000_000
  defguard is_thousand(val) when val >= 1_000 and val < 1_000_000
  defguard is_hundred(val) when val >= 100 and val < 1_000
  defguard is_ty(val) when val >= 20 and val < 100
  defguard is_teen(val) when val >= 10 and val < 20
  defguard is_literal(val) when val >= 1 and val < 10
  defguard is_negative(val) when val < 0
  defguard is_too_big(val) when val > 999_999_999_999

  defguard is_even_hundred(num) when rem(num, 100) == 0
  defguard is_even_ten(num) when rem(num, 10) == 0

  @doc """
  For enunciate to work, the System outside of elixir will need to have
  espeak installed (on some linux systems, running `sudo apt-get espeak`
  should do the trick)

  Enunciate takes a range or integer and tells the outside operating system
  to say that integer or that range.
  """
  def enunciate(first .. last) do
    for i <- first .. last, do: enunciate(i)
  end

  def enunciate(number) do
    case in_english(number) do
      {:ok, text} -> System.cmd("espeak", [text])
      {:error, error_text} -> System.cmd("espeak", ["error! " <> error_text])
    end
  end

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(num) when not is_integer(num), do: {:error, "not an integer"}
  def in_english(num) when is_negative(num) or is_too_big(num), do: {:error, "number is out of range"}
  def in_english(0), do: {:ok, "zero"}
  def in_english(num) when is_integer(num) do
    result = num |> chunkify() |> scale_words()

    {:ok, result}
  end

  defp chunkify(number) do
    number
    |> Integer.digits()
    |> chunk_in_threes_from_decimal()
    |> Enum.map(&Integer.undigits/1)
  end

  defp chunk_in_threes_from_decimal(digit_list) do
    digit_list
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
  end

  def scale_words([first | [0]]), do: translate(first) <> " thousand"

  def scale_words([first | [0, 0]]), do: translate(first) <> " million"

  def scale_words([first | [0, 0, 0]]), do: translate(first) <> " billion"

  def scale_words([first | rest] = chunks) do
    case length(chunks) do
      4 -> translate(first) <> " billion " <> scale_words(rest)
      3 -> translate(first) <> " million " <> scale_words(rest)
      2 -> translate(first) <> " thousand " <> scale_words(rest)
      1 -> translate(first)
    end
  end
  
  def translate(number) when is_hundred(number), do: meld_hundred(number)
  def translate(number) when is_ty(number), do: meld_ty(number)
  def translate(number) when is_teen(number), do: meld_tens(number)
  def translate(number) when is_literal(number), do: literal(number)
  def translate(0), do: ""

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
  defp meld_tens(num) when is_ty(num), do: meld_ty(num)

  defp meld_ty(20), do: "twenty"
  defp meld_ty(30), do: "thirty"
  defp meld_ty(40), do: "forty"
  defp meld_ty(50), do: "fifty"
  defp meld_ty(80), do: "eighty"
  defp meld_ty(num) when is_even_ten(num) do
    ten_magnigtude = num / 10 |> round() |> translate()
    ten_magnigtude <> "ty"
  end

  defp meld_ty(num) do
    tens_num = rem(num, 10) |> round()
    translate(num - tens_num) <> "-" <> translate(tens_num)
  end

  defp meld_hundred(num) when is_even_hundred(num) do
    hundred_magnitude = num / 100 |> round() |> translate()
    hundred_magnitude <> " hundred"
  end

  defp meld_hundred(num) do
    hundreds_num = rem(num, 100) |> round()
    translate(num - hundreds_num) <> " " <> translate(hundreds_num)
  end
end
