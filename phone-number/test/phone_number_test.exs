defmodule PhoneTest do
  use ExUnit.Case

  test "area code no punctuation" do
    assert Phone.area_code("2125550100") == "212"
  end

  test "local number no punctuation" do
    assert Phone.local_number("2125550100") == "5550100"
  end

  test "just area code 1 and space" do
    assert Phone.area_code("+1 (314) 473-4200") == "314"
  end

  test "just area code 1 and hyphen" do
    assert Phone.area_code("+1 (314)-473-4200") == "314"
  end

  test "just area code 1 and all spaces" do
    assert Phone.area_code("1 314 473 4200") == "314"
  end

  test "just area code just hyphens" do
    assert Phone.area_code("314-473-4200") == "314"
  end

  test "just area code hyphen and parens" do
    assert Phone.area_code("(314)-473-4200") == "314"
  end

  test "just area code space and parens" do
    assert Phone.area_code("(314) 473-4200") == "314"
  end

  test "just area code dots" do
    assert Phone.area_code("314.473.4200") == "314"
  end


  test "local number 1 and space" do
    assert Phone.local_number("+1 (314) 473-4200") == "4734200"
  end

  test "local number 1 and hyphen" do
    assert Phone.local_number("+1 (314)-473-4200") == "4734200"
  end

  test "local number 1 all space" do
    assert Phone.local_number("1 314 473 4200") == "4734200"
  end

  test "local number hyphens" do
    assert Phone.local_number("314-473-4200") == "4734200"
  end

  test "local number hyphens and parens" do
    assert Phone.local_number("(314)-473-4200") == "4734200"
  end

  test "local number space and parens" do
    assert Phone.local_number("(314) 473-4200") == "4734200"
  end

  test "local number dots" do
    assert Phone.local_number("314.473.4200") == "4734200"
  end
  

  # @tag :pending
  test "cleans number" do
    assert Phone.number("(212) 555-0100") == "2125550100"
  end

  # @tag :pending
  test "cleans number with dots" do
    assert Phone.number("212.555.0100") == "2125550100"
  end

  # @tag :pending
  test "valid when 11 digits and first is 1" do
    assert Phone.number("12125550100") == "2125550100"
  end

  # @tag :pending
  test "valid when 11 digits and some decorations" do
    assert Phone.number("+1 (212) 555-0100") == "2125550100"
  end

  # @tag :pending
  test "invalid when country calling code is not 1" do
    assert Phone.number("22125550100") == "0000000000"
  end

  # @tag :pending
  test "invalid when 9 digits" do
    assert Phone.number("212555010") == "0000000000"
  end

  # @tag :pending
  test "invalid when proper number of digits but letters mixed in" do
    assert Phone.number("2a1a2a5a5a5a0a1a0a0a") == "0000000000"
  end

  # @tag :pending
  test "invalid with correct number of characters but some are letters" do
    assert Phone.number("2a1a2a5a5a") == "0000000000"
  end

  # @tag :pending
  test "invalid when area code begins with 1" do
    assert Phone.number("1125550100") == "0000000000"
  end

  # @tag :pending
  test "invalid when area code begins with 0" do
    assert Phone.number("0125550100") == "0000000000"
  end

  # @tag :pending
  test "invalid when exchange code begins with 1" do
    assert Phone.number("2121550100") == "0000000000"
  end

  # @tag :pending
  test "invalid when exchange code begins with 0" do
    assert Phone.number("2120550100") == "0000000000"
  end

  # @tag :pending
  test "area code" do
    assert Phone.area_code("2125550100") == "212"
  end

  # @tag :pending
  test "area code with full US phone number" do
    assert Phone.area_code("12125550100") == "212"
  end

  # @tag :pending
  test "invalid area code" do
    assert Phone.area_code("(100) 555-1234") == "000"
  end

  # @tag :pending
  test "no area code" do
    assert Phone.area_code("867.5309") == "000"
  end

  # @tag :pending
  test "pretty print" do
    assert Phone.pretty("2125550100") == "(212) 555-0100"
  end

  # @tag :pending
  test "pretty print with full US phone number" do
    assert Phone.pretty("+1 (303) 555-1212") == "(303) 555-1212"
  end

  # @tag :pending
  test "pretty print invalid US phone number" do
    assert Phone.pretty("212-155-0100") == "(000) 000-0000"
  end

  # @tag :pending
  test "pretty print invalid, short US phone number" do
    assert Phone.pretty("867.5309") == "(000) 000-0000"
  end
end
