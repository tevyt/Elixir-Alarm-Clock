defmodule AlarmClock do
  @moduledoc """
  Main module for the alarm clock project all logic for the application lives here.
  """
  def parse_args(args) do
    parsed = OptionParser.parse(args, switches: [hour: :integer, minute: :integer, period: :string]) 
    case parsed do
      {[hour: hour], _, _} -> {hour, 0, "am"}
      {[hour: hour, minute: minute], _, _} -> {hour, minute, "am"}
      {[hour: hour, minute: minute, period: period], _, _} -> {hour, minute, period}
      _ -> {:error, "Invalid usage"}
    end
  end

  def date_time_from_args(time_args) do
    current_date_time = DateTime.utc_now
    case time_args do
      {hour, minute, "am"} -> current_date_time
      |> Map.update!(:hour, fn(_) -> hour + 5 end) #Convert to my timezone, not much built-in Timezone handling in Elixir yet
      |> Map.update!(:minute, fn(_) -> minute end)
      {hour, minute, "pm"} -> current_date_time
      |> Map.update!(:hour, fn(_)  -> hour + 17 end)
      |> Map.update!(:minute, fn(_) -> minute end)
    end
  end

  @doc """
  Main function entry point of the program
  """
  def main(args) do
    args
    |> parse_args
    |> date_time_from_args
    |> IO.inspect
  end
end
