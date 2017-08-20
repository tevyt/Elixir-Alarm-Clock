defmodule AlarmClock do
  @moduledoc """
  Main remule for the alarm clock project all logic for the application lives here.
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
    #Convert to my timezone, by adding 5 hours not much built-in Timezone handling in Elixir yet
    case time_args do
      {hour, _, "am"} -> current_date_time |> Map.update!(:hour, fn(_) -> rem(hour + 5, 24) end) 
      {hour, _, "pm"} -> current_date_time |> Map.update!(:hour, fn(_)  -> rem(hour + 17, 24) end)
    end
    |> Map.update!(:minute, fn(_) -> elem(time_args, 1) end)
    |> Map.update!(:second, fn(_) -> 0 end)
  end

  def set_alarm(alarm_time) do
    current_time = DateTime.utc_now
    case DateTime.compare(current_time, alarm_time) do
      :gt -> IO.puts "Alarm Triggered GT"
      :eq -> IO.puts "Alarm Triggered EQ"
      _ -> set_alarm(alarm_time)
    end
  end

  def read_video_list do
    {_, file_content} = File.read("./video_list.txt")
    file_content
		|>  String.trim
		|>  String.split("\n")
	end

  def randomly_select_video(video_list) do
    youtube_base_url = "https://www.youtube.com/watch?v="
    selected_video = video_list |> Enum.random
    youtube_base_url <> selected_video
  end

  @doc """
  Main function entry point of the program
  """
  def main(args) do
    args
    |> parse_args
    |> date_time_from_args
    |> set_alarm

    System.cmd("sensible-browser", [read_video_list() |> randomly_select_video])
  end
end
