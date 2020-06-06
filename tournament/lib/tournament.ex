defmodule Tournament do
  defstruct team_counter: %{}
  @type team_record :: {wins :: integer, draws :: integer, losses :: integer}
  @type game_info :: {team1 :: String.t(), team2 :: String.t(), outcome :: String.t()}
  @type game_records :: %{optional(String.t()) => team_record}
  @type t :: %__MODULE__{team_counter: game_records}

  @blank_record {0, 0, 0}

  @divider_character ";"
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    process_games(input)
    |> pretty_print()
  end

  def update_struct(new_game_thruple, struct_acc) do
    %{struct_acc | team_counter: add_game(struct_acc.team_counter, new_game_thruple)}
  end

  def process_games(input) do
    input
    # split each item_in_input on semicolons
    |> Enum.map(&String.split(&1, @divider_character))
    # put each item_in_input into a tuple (length three)
    |> Enum.map(&List.to_tuple/1)
    # reduce each item in updated struct on each
    |> Enum.reduce(%__MODULE__{}, &update_struct/2)
  end

  @spec add_game(game_recs :: game_records, new_game :: game_info) :: game_records
  defp add_game(game_recs, {winner, loser, "win"}) do
    update_winner_and_loser(winner, loser, game_recs)
  end

  defp add_game(game_recs, {loser, winner, "loss"}) do
    update_winner_and_loser(winner, loser, game_recs)
  end

  defp add_game(game_recs, {home, away, "draw"}) do
    update_tie(home, away, game_recs)
  end

  defp add_game(game_recs, _anything_else) do
    game_recs
  end

  defp update_winner_and_loser(winner, loser, game_recs) do
    cond do
      has_team_recorded?(game_recs, winner) and has_team_recorded?(game_recs, loser) -> 
        %{^winner => winner_record, ^loser => loser_record} = game_recs
        do_update_winner_and_loser(winner, loser, winner_record, loser_record, game_recs)

      has_team_recorded?(game_recs, winner) ->
        %{^winner => winner_record} = game_recs
        loser_record = nil

        do_update_winner_and_loser(winner, loser, winner_record, loser_record, game_recs)


      has_team_recorded?(game_recs, loser) ->
        %{^loser => loser_record} = game_recs
        winner_record = nil

        do_update_winner_and_loser(winner, loser, winner_record, loser_record, game_recs)
      true ->
        loser_record = nil
        winner_record = nil

        do_update_winner_and_loser(winner, loser, winner_record, loser_record, game_recs)
    end
  end

  defp do_update_winner_and_loser(winner, loser, winner_record, loser_record, game_recs) do
    Map.put(game_recs, winner, add_win(winner_record))
    |> Map.put(loser, add_loss(loser_record))
  end


  defp update_tie(home, away, game_recs) do
    cond do
      has_team_recorded?(game_recs, home) and has_team_recorded?(game_recs, away) ->
        %{^home => home_record, ^away => away_record} = game_recs
        do_update_tie(home, away, home_record, away_record, game_recs)

      has_team_recorded?(game_recs, home) ->
        %{^home => home_record} = game_recs
        away_record = nil
        do_update_tie(home, away, home_record, away_record, game_recs)

      has_team_recorded?(game_recs, away) ->
        %{^away => away_record} = game_recs
        home_record = nil
        do_update_tie(home, away, home_record, away_record, game_recs)

      true ->
        away_record = nil
        home_record = nil
        do_update_tie(home, away, home_record, away_record, game_recs)
    end
  end

  defp do_update_tie(home, away, home_rec, away_rec, game_recs) do
    Map.put(game_recs, home, add_tie(home_rec))
    |> Map.put(away, add_tie(away_rec))
  end

  defp add_win({wins, draws, losses}) do
    {wins + 1, draws, losses}
  end

  defp add_win(nil) do
    add_win(@blank_record)
  end

  defp add_loss({wins, draws, losses}) do
    {wins, draws, losses + 1}
  end

  defp add_loss(nil) do
    add_loss(@blank_record)
  end

  defp add_tie({wins, draws, losses}) do
    {wins, draws + 1, losses}
  end

  defp add_tie(nil) do
    add_tie(@blank_record)
  end

  defp has_team_recorded?(game_recs, team) do
    game_recs[team] != nil
  end

  defp pretty_print(tournament) do
    tournament.team_counter
    |> Map.to_list()
    |> Enum.map(fn {team, {w, d, l}} -> {team, {w, d, l}, count_points(w, d, l)} end)
    |> Enum.map(fn {team, {w, d, l}, pts} -> {team, {Enum.sum([w, d, l]), w, d, l}, pts} end)
    |> Enum.sort(fn
      {_, _, these_points}, {_, _, those_points} ->
        these_points >= those_points
    end)
    |> Enum.map(fn {name, {mp, w, d, l}, pts} -> {name, mp, w, d, l, pts} end)
    |> add_formatting()
  end

  defp count_points(wins, draws, _losses) do
    wins * 3 + draws
  end

  defp add_formatting(sorted_team_records) do
    [{"Team", "MP", "W", "D", "L", "P"} | sorted_team_records]
    |> Enum.map(fn {name, mp, w, d, l, pts} -> pad_line(name, mp, w, d, l, pts) end)
    |> Enum.join("\n")
  end

  defp pad_line(name, matches_played, wins, draws, losses, points) do
    list_o_num_columns = [matches_played, wins, draws, losses, points] |> Enum.map(&pad_num_column/1)

    [pad_name_column(name) | list_o_num_columns]
    |> Enum.join(" |")
  end

  defp pad_num_column(item) do
    item
    |> to_string()
    |> String.pad_leading(3)
  end

  defp pad_name_column(item) do
    String.pad_trailing(item, 30)
  end
end
