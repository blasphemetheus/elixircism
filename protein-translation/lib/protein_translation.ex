defmodule ProteinTranslation do
  @stop_message "STOP"

  @codon_to_protein %{
    'UGU' => "Cysteine",
    'UGC' => "Cysteine",
    'UUA' => "Leucine",
    'UUG' => "Leucine",
    'AUG' => "Methionine",
    'UUU' => "Phenylalanine",
    'UUC' => "Phenylalanine",
    'UCU' => "Serine",
    'UCC' => "Serine",
    'UCA' => "Serine",
    'UCG' => "Serine",
    'UGG' => "Tryptophan",
    'UAU' => "Tyrosine",
    'UAC' => "Tyrosine",
    'UAA' => @stop_message,
    'UAG' => @stop_message,
    'UGA' => @stop_message
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    to_charlist(rna)
    |> Enum.chunk_every(3)
    |> Enum.map(fn codon_raw -> of_codon(codon_raw) end)
    # at this point it's a list of {:ok, "<some_protein>"}, {:ok, "STOP"} or {:error, "some_msg"}
    |> snip_stop_codons()
    |> consolidate_values()
  end

  @spec snip_stop_codons(list_o_tuples :: list(tuple)) :: list(tuple)
  defp snip_stop_codons(list_o_tuples) do
    if list_o_tuples == [] do
      []
    else
      case list_o_tuples do
        [{:error, message} | tail] -> [{:error, message}] ++ snip_stop_codons(tail)
        [{:ok, @stop_message} | _] -> []
        [{:ok, message} | tail] -> [{:ok, message}] ++ snip_stop_codons(tail)
      end
    end
  end

  # consolidates the list of tuples into a single tuple. If there is an
  # error atom in the mix then an error is returned, otherwise ok is returned
  @spec consolidate_values(list_o_tuples :: list(tuple)) :: {atom, any}
  defp consolidate_values(list_o_tuples) do
    if Enum.find(list_o_tuples, fn {status, _} -> status == :error end) do
      {:error, "invalid RNA"}
    else
      list_ok = for {:ok, message} <- list_o_tuples, true, do: message
      {:ok, list_ok}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU => Cysteine
  UGC => Cysteine
  UUA => Leucine
  UUG => Leucine
  AUG => Methionine
  UUU => Phenylalanine
  UUC => Phenylalanine
  UCU => Serine
  UCC => Serine
  UCA => Serine
  UCG => Serine
  UGG => Tryptophan
  UAU => Tyrosine
  UAC => Tyrosine
  UAA => STOP
  UAG => STOP
  UGA => STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    raw_codon = @codon_to_protein[to_charlist(codon)]
    if raw_codon == nil do
      {:error, "invalid codon"}
    else
      {:ok, raw_codon}
    end
  end
end
