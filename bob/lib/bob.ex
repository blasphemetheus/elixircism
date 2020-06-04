defmodule Bob do
  def hey(input) do
    splitted = String.split(input)
    input_no_spaces = to_string(splitted)
    cond do
      empty?(input_no_spaces) -> "Fine. Be that way!"
      question?(input_no_spaces) and yelling_with_text?(input_no_spaces) ->
        "Calm down, I know what I'm doing!"
      question?(input_no_spaces) -> "Sure."
      yelling_with_text?(input_no_spaces) and case_insensitive?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp case_insensitive?(input) do
    String.downcase(input) != String.upcase(input)
  end

  defp question?(input) do
    String.last(input) == "?"
  end

  defp yelling_with_text?(input) do
    String.upcase(input) == input and case_insensitive?(input)
  end

  defp empty?(input) do
    input == ""
  end

end
