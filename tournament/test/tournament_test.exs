defmodule TournamentTest do
  use ExUnit.Case

  test "update_struct unseen win/loss" do
    empty_tourney = %Tournament{}
    thruple = {"Winner", "Loser", "win"}

    expected = %Tournament{:team_counter => %{"Winner" => {1,0,0}, "Loser" => {0,0,1}}}

    assert Tournament.update_struct(thruple, empty_tourney) == expected
  end

  test "update_struct seen both winner and loser" do
    tourney = %Tournament{:team_counter => %{"Winner" => {0,1,0}, "Loser" => {0,1,0}}}
    win = {"Winner", "Loser", "win"}
    draw = {"Winner", "Loser", "draw"}

    expected = %Tournament{:team_counter => %{"Winner" => {1,1,0}, "Loser" => {0,1,1}}}
    draw_expected = %Tournament{:team_counter => %{"Winner" => {0,2,0}, "Loser" => {0,2,0}}}

    assert Tournament.update_struct(win, tourney) == expected
    assert Tournament.update_struct(draw, tourney) == draw_expected
  end

  test "update_struct seen only first" do
    tourney = %Tournament{:team_counter => %{"Winner" => {0,1,0}}}
    thruple = {"Winner", "Loser", "win"}
    draw = {"Winner", "Loser", "draw"}

    expected = %Tournament{:team_counter => %{"Winner" => {1,1,0}, "Loser" => {0,0,1}}}
    draw_expected = %Tournament{:team_counter => %{"Winner" => {0,2,0}, "Loser" => {0,1,0}}}

    assert Tournament.update_struct(thruple, tourney) == expected
    assert Tournament.update_struct(draw, tourney) == draw_expected
  end

  test "update_struct seen only second" do
    tourney = %Tournament{:team_counter => %{"Loser" => {0,1,0}}}
    thruple = {"Winner", "Loser", "win"}
    draw = {"Winner", "Loser", "draw"}

    expected = %Tournament{:team_counter => %{"Winner" => {1,0,0}, "Loser" => {0,1,1}}}
    draw_expected = %Tournament{:team_counter => %{"Winner" => {0,1,0}, "Loser" => {0,2,0}}}

    assert Tournament.update_struct(thruple, tourney) == expected
    assert Tournament.update_struct(draw, tourney) == draw_expected
  end

  # test "the intake of the teams happened right?" do
  #   sample_input = [
  #     "Fun;Boring;win", "Fun;Mild;win", "Yeet;Mild;win", "Boring;Fun;win",
  #     "Boring;Fun;draw", "Lukewarm;Fun;draw", "Fun;Zanzibar;draw", "Leek;Soup;draw",
  #     "Fun;Boring;loss", "Stupid;Horse;loss", "Horse;Rider;loss", "Rider;Hoarse;loss"
  #   ]
    
  #   expected = %Tournament{team_counter: "stuff"}

  #   #TODO
  # end

  # @tag :pending
  test "get a tournament struct of a specific type" do
    sample_input = [
      "Fun;Boring;win", "Fun;Mild;win", "Yeet;Mild;win", "Boring;Fun;win",
      "Boring;Fun;draw", "Lukewarm;Fun;draw", "Fun;Zanzibar;draw", "Leek;Soup;draw",
      "Fun;Boring;loss", "Stupid;Horse;loss", "Horse;Rider;loss", "Rider;Hoarse;loss"] 

  
    # expected_a = %Tournament{}

    expected = %Tournament{team_counter: %{
      "Fun" => {2,3,2},
      "Boring" => {2,1,1},
      "Mild" => {0,0,2},
      "Yeet" => {1,0,0},
      "Lukewarm" => {0,1,0},
      "Zanzibar" => {0,1,0},
      "Leek" => {0,1,0},
      "Soup" => {0,1,0},
      "Stupid" => {0,0,1},
      "Horse" => {1,0,1},
      "Rider" => {1,0,1},
      "Hoarse" => {1,0,0}
    }}

    assert Tournament.process_games(sample_input) == expected
  end

  # @tag :pending
  test "typical input" do
    input = [
      "Allegoric Alaskans;Blithering Badgers;win",
      "Devastating Donkeys;Courageous Californians;draw",
      "Devastating Donkeys;Allegoric Alaskans;win",
      "Courageous Californians;Blithering Badgers;loss",
      "Blithering Badgers;Devastating Donkeys;loss",
      "Allegoric Alaskans;Courageous Californians;win"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  3 |  2 |  1 |  0 |  7
      Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
      Blithering Badgers             |  3 |  1 |  0 |  2 |  3
      Courageous Californians        |  3 |  0 |  1 |  2 |  1
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end

  # @tag :pending
  test "incomplete competition (not all pairs have played)" do
    input = [
      "Allegoric Alaskans;Blithering Badgers;loss",
      "Devastating Donkeys;Allegoric Alaskans;loss",
      "Courageous Californians;Blithering Badgers;draw",
      "Allegoric Alaskans;Courageous Californians;win"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Allegoric Alaskans             |  3 |  2 |  0 |  1 |  6
      Blithering Badgers             |  2 |  1 |  1 |  0 |  4
      Courageous Californians        |  2 |  0 |  1 |  1 |  1
      Devastating Donkeys            |  1 |  0 |  0 |  1 |  0
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end

  # @tag :pending
  test "ties broken alphabetically" do
    input = [
      "Courageous Californians;Devastating Donkeys;win",
      "Allegoric Alaskans;Blithering Badgers;win",
      "Devastating Donkeys;Allegoric Alaskans;loss",
      "Courageous Californians;Blithering Badgers;win",
      "Blithering Badgers;Devastating Donkeys;draw",
      "Allegoric Alaskans;Courageous Californians;draw"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Allegoric Alaskans             |  3 |  2 |  1 |  0 |  7
      Courageous Californians        |  3 |  2 |  1 |  0 |  7
      Blithering Badgers             |  3 |  0 |  1 |  2 |  1
      Devastating Donkeys            |  3 |  0 |  1 |  2 |  1
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end

  # @tag :pending
  test "mostly invalid lines" do
    # Invalid input lines in an otherwise-valid game still results in valid
    # output.
    input = [
      "",
      "Allegoric Alaskans@Blithering Badgers;draw",
      "Blithering Badgers;Devastating Donkeys;loss",
      "Devastating Donkeys;Courageous Californians;win;5",
      "Courageous Californians;Allegoric Alaskans;los"
    ]

    expected =
      """
      Team                           | MP |  W |  D |  L |  P
      Devastating Donkeys            |  1 |  1 |  0 |  0 |  3
      Blithering Badgers             |  1 |  0 |  0 |  1 |  0
      """
      |> String.trim()

    assert Tournament.tally(input) == expected
  end
end
