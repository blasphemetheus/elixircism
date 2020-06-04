defmodule Phone do
  @plus_one_paren_pattern ~r/^\+1 \([2-9][0-9][0-9]\).[2-9][0-9][0-9].[0-9][0-9][0-9][0-9]$/
  @one_with_buffer_character ~r/^1.[2-9][0-9][0-9].[2-9][0-9][0-9].[0-9][0-9][0-9][0-9]$/
  @one_no_buffer ~r/^1[2-9][0-9][0-9][2-9][0-9][0-9][0-9][0-9][0-9][0-9]$/
  @parens_and_buffer ~r/^\([2-9][0-9][0-9]\).[2-9][0-9][0-9].[0-9][0-9][0-9][0-9]$/
  @with_buffer ~r/^[2-9][0-9][0-9].[2-9][0-9][0-9].[0-9][0-9][0-9][0-9]$/
  @no_buffer ~r/^[2-9][0-9][0-9][2-9][0-9][0-9][0-9][0-9][0-9][0-9]$/
  @local_number_with_buffer ~r/^[2-9][0-9][0-9].[0-9][0-9][0-9][0-9]$/
  @local_number_no_buffer ~r/^[2-9][0-9][0-9][0-9][0-9][0-9][0-9]$/
  @any ~r/./
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    area_code(raw) <> local_number(raw)
  end

  def local_number(raw) do
    cond do
      # recursive cases
      String.match?(raw, @plus_one_paren_pattern) -> local_number(String.slice(raw, 9, 8))
      String.match?(raw, @one_with_buffer_character) -> local_number(String.slice(raw, 6, 8))
      String.match?(raw, @one_no_buffer) -> local_number(String.slice(raw, 1, 10))
      String.match?(raw, @parens_and_buffer) -> local_number(String.slice(raw, 6, 8))
      String.match?(raw, @with_buffer) -> local_number(String.slice(raw, 4, 8))
      String.match?(raw, @no_buffer) -> local_number(String.slice(raw, 3, 7))
      # base cases
      String.match?(raw, @local_number_with_buffer) -> String.slice(raw, 0, 3) <> String.slice(raw, 4, 4)
      String.match?(raw, @local_number_no_buffer) -> raw
      # invalid format (default) case
      String.match?(raw, @any) -> String.duplicate("0", 7)
    end
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    cond do
      # recursive cases
      String.match?(raw, @plus_one_paren_pattern) -> area_code(String.slice(raw, 3, 14))
      String.match?(raw, @one_with_buffer_character) -> area_code(String.slice(raw, 2, 12))
      String.match?(raw, @one_no_buffer) -> area_code(String.slice(raw, 1, 10))
      # base cases
      String.match?(raw, @parens_and_buffer) -> String.slice(raw, 1, 3)
      String.match?(raw, @with_buffer) -> String.slice(raw, 0, 3)
      String.match?(raw, @no_buffer) -> String.slice(raw, 0, 3)
      # invalid case (defaults to zeros)
      String.match?(raw, @any) -> String.duplicate("0", 3)
    end
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    number = Phone.number(raw)
    area_code = String.slice(number, 0, 3)
    local_number = String.slice(number, 3, 7)
    exchange_code = String.slice(local_number, 0, 3)
    subscriber_number = String.slice(local_number, 3, 4)
    if area_code != String.duplicate("0", 3) and local_number != String.duplicate("0", 7) do
      "(#{area_code}) #{exchange_code}-#{subscriber_number}"
    else
      "(#{String.duplicate("0", 3)}) #{String.duplicate("0", 3)}-#{String.duplicate("0", 4)}"
    end
  end
end
