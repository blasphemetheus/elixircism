defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    produce(year, month, weekday_2_num(weekday), schedule)
  end

  defp weekday_2_num(:monday), do: 1
  defp weekday_2_num(:tuesday), do: 2
  defp weekday_2_num(:wednesday), do: 3
  defp weekday_2_num(:thursday), do: 4
  defp weekday_2_num(:friday), do: 5
  defp weekday_2_num(:saturday), do: 6
  defp weekday_2_num(:sunday), do: 7

  defp produce(year, month, weekday, :first) do
    first_of_month = Date.new(year, month, 1) |> extract()

    weekday_o_first = Date.day_of_week(first_of_month)
    days_after_first = weekday - weekday_o_first |> Integer.mod(7)

    new_date = Date.new(year, month, 1 + days_after_first) |> extract()

    new_date
  end

  defp produce(year, month, weekday, :second) do
    produce(year, month, weekday, :first)
    |> Date.add(7)
  end

  defp produce(year, month, weekday, :third) do
    produce(year, month, weekday, :second)
    |> Date.add(7)
  end

  defp produce(year, month, weekday, :fourth) do
    produce(year, month, weekday, :third)
    |> Date.add(7)
  end

  defp produce(year, month, weekday, :last) do
    days_in_month = produce(year, month, weekday, :first)
    |> Date.days_in_month()

    last_o_month = Date.new(year, month, days_in_month) |> extract()
    weekday_o_last = Date.day_of_week(last_o_month)
    days_before_last = (weekday_o_last - weekday) |> Integer.mod(7)

    new_date = Date.new(year, month, days_in_month - days_before_last) |> extract()

    # give_info(weekday, new_date, days_before_last, weekday_o_last, last_o_month)
    new_date

  end

  defp produce(year, month, weekday, :teenth) do
    thirteenth = Date.new(year, month, 13) |> extract()

    weekday_o_thirt = Date.day_of_week(thirteenth)
    days_after_thirt = weekday - weekday_o_thirt |> Integer.mod(7)

    Date.new(year, month, 13 + days_after_thirt)
    |> extract()
  end

  defp extract({:ok, date}), do: date
end
