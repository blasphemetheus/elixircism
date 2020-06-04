defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  Both DNA and RNA are sequences of nucleotides ()
  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """

  # Uses Enum.map to run through the inputted charlist
  # and run parse_char on each element
  def to_rna(raw) do
    Enum.map(raw, &parse_char/1)
  end

  ###################################

  # parse catches specific characters and
  # returns a translated charlist
  @spec parse_char(char) :: [char]
  defp parse_char(?G) do
    ?C
  end

  defp parse_char(?C) do
    ?G
  end

  defp parse_char(?A) do
    ?U
  end

  defp parse_char(?T) do
    ?A
  end
end
