defmodule RnaTranscriptionTest do
  use ExUnit.Case

  # test "process a single char, not a signifier" do
  #   assert RnaTranscription.to_rna('_') == '_'
  # end

  test "process a single char, a signifier" do
    assert RnaTranscription.to_rna('A') == 'U'
  end

  test "process another signifier" do
    assert RnaTranscription.to_rna('G') == 'C'
  end

  # test "process a lowercase (non-sig)" do
  #   assert RnaTranscription.to_rna('g') == 'g'
  # end

  # test "hmm" do
  #   assert RnaTranscription.to_rna('uuu') == 'uuu'
  # end

  # @tag :pending
  test "transcribes guanine to cytosine" do
    assert RnaTranscription.to_rna('G') == 'C'
  end

  # test "transcribe a real, a fake, and another real successfully" do
  #   assert RnaTranscription.to_rna('G_C') == 'C_G'
  # end

  test "transcribes nothing to nothing" do
    assert RnaTranscription.to_rna('') == ''
  end

  # test "transcribes invalid shite to itself" do
  #   assert RnaTranscription.to_rna('bloop') == 'bloop'
  # end

  # test "transcribes lower case in now way" do
  #   assert RnaTranscription.to_rna('gcta') == 'gcta'
  # end

  # @tag :pending
  test "transcribes cytosine to guanine" do
    assert RnaTranscription.to_rna('C') == 'G'
  end

  # @tag :pending
  test "transcribes thymidine to adenine" do
    assert RnaTranscription.to_rna('T') == 'A'
  end

  # @tag :pending
  test "transcribes adenine to uracil" do
    assert RnaTranscription.to_rna('A') == 'U'
  end

  # @tag :pending
  test "it transcribes all dna nucleotides to rna equivalents" do
    assert RnaTranscription.to_rna('ACGTGGTCTTAA') == 'UGCACCAGAAUU'
  end
end
