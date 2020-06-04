defmodule NucleotideCountTest do
  use ExUnit.Case

  test "match true when there is a match" do
    assert NucleotideCount.match(?A, ?A) == true
  end

  test "match false when comparing a char to a charlist" do
    assert NucleotideCount.match(?Q, 'Q') == false
  end

  test "match false when char to multiple charlist" do
    assert NucleotideCount.match(?Q, 'QT') == false
  end

  test "match false when incorrect character" do
    assert NucleotideCount.match(?Q, ?T) == false
  end

  # @tag :pending
  test "empty dna string has no adenine" do
    assert NucleotideCount.count('', ?A) == 0
  end

  test "three adenines get counted" do
    assert NucleotideCount.count('AAA', ?A) == 3
  end

  # @tag :pending
  test "repetitive cytosine gets counted" do
    assert NucleotideCount.count('CCCCC', ?C) == 5
  end

  # @tag :pending
  test "counts only thymine" do
    assert NucleotideCount.count('GGGGGTAACCCGG', ?T) == 1
  end

  # @tag :pending
  test "empty dna string has no nucleotides" do
    expected = %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
    assert NucleotideCount.histogram('') == expected
  end

  # @tag :pending
  test "repetitive sequence has only guanine" do
    expected = %{?A => 0, ?T => 0, ?C => 0, ?G => 8}
    assert NucleotideCount.histogram('GGGGGGGG') == expected
  end

  # @tag :pending
  test "counts all nucleotides" do
    s = 'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
    expected = %{?A => 20, ?T => 21, ?C => 12, ?G => 17}
    assert NucleotideCount.histogram(s) == expected
  end
end
