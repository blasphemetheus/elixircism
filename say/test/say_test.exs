defmodule SayTest do
  use ExUnit.Case

  # test "chunk (now a private function)" do
  #   assert Say.chunkify(1_234_567_890) == [1, 234, 567, 890]
  #   assert Say.chunkify(100) == [100]
  #   assert Say.chunkify(1_000) == [1, 0]
  #   assert Say.chunkify(90_000) == [90, 0]
  #   assert Say.chunkify(90_090) == [90, 90]
  #   assert Say.chunkify(90_900) == [90, 900]
  # end

  # @tag :pending
  test "zero" do
    assert Say.in_english(0) == {:ok, "zero"}
  end

  # @tag :pending
  test "one" do
    assert Say.in_english(1) == {:ok, "one"}
  end

  test "10" do
    assert Say.in_english(10) == {:ok, "ten"}
  end

  test "12" do
    assert Say.in_english(12) == {:ok, "twelve"}
  end

  # @tag :pending
  test "fourteen" do
    assert Say.in_english(14) == {:ok, "fourteen"}
  end

  test "15" do
    assert Say.in_english(15) == {:ok, "fifteen"}
  end

  test "18" do
    assert Say.in_english(18) == {:ok, "eighteen"}
  end

  # @tag :pending
  test "twenty" do
    assert Say.in_english(20) == {:ok, "twenty"}
  end

  # @tag :pending
  test "twenty-two" do
    assert Say.in_english(22) == {:ok, "twenty-two"}
  end

  test "28" do
    assert Say.in_english(28) == {:ok, "twenty-eight"}
  end

  test "50" do
    assert Say.in_english(50) == {:ok, "fifty"}
  end

  test "98" do
    assert Say.in_english(98) == {:ok, "ninety-eight"}
  end

  # @tag :pending
  test "one hundred" do
    assert Say.in_english(100) == {:ok, "one hundred"}
  end

  test "101" do
    assert Say.in_english(101) == {:ok, "one hundred one"}
  end

  test "103" do
    assert Say.in_english(103) == {:ok, "one hundred three"}
  end

  # @tag :pending
  test "one hundred twenty-three" do
    assert Say.in_english(123) == {:ok, "one hundred twenty-three"}
  end

  test "509" do
    assert Say.in_english(509) == {:ok, "five hundred nine"}
  end

  test "800" do
    assert Say.in_english(800) == {:ok, "eight hundred"}
  end

  test "828" do
    assert Say.in_english(828) == {:ok, "eight hundred twenty-eight"}
  end

  test "990" do
    assert Say.in_english(990) == {:ok, "nine hundred ninety"}
  end

  # @tag :pending
  test "one thousand" do
    assert Say.in_english(1_000) == {:ok, "one thousand"}
  end

  # @tag :pending
  test "one thousand two hundred thirty-four" do
    assert Say.in_english(1_234) == {:ok, "one thousand two hundred thirty-four"}
  end

  # @tag :pending
  test "one million" do
    assert Say.in_english(1_000_000) == {:ok, "one million"}
  end

  # @tag :pending
  test "one million two thousand three hundred forty-five" do
    assert Say.in_english(1_002_345) == {:ok, "one million two thousand three hundred forty-five"}
  end

  # @tag :pending
  test "one billion" do
    assert Say.in_english(1_000_000_000) == {:ok, "one billion"}
  end

  # @tag :pending
  test "a big number" do
    assert Say.in_english(987_654_321_123) ==
             {:ok,
              "nine hundred eighty-seven billion six hundred fifty-four million three hundred twenty-one thousand one hundred twenty-three"}
  end

  # @tag :pending
  test "numbers below zero are out of range" do
    assert Say.in_english(-1) == {:error, "number is out of range"}
  end

  # @tag :pending
  test "numbers above 999,999,999,999 are out of range" do
    assert Say.in_english(1_000_000_000_000) == {:error, "number is out of range"}
  end
end
