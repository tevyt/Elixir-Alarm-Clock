defmodule AlarmClock do
  @moduledoc """
  Main module for the alarm clock project all logic for the application lives here.
  """
  def parse_args(args) do
    case OptionParser.parse(args, switches: [hour: :integer]) do
      {[hour: hour], _, _} -> hour
      _ -> {:error, "Invalid usage"}
    end
  end

  @doc """
  Main function entry point of the program
  """
  def main(args) do
    args
    |> parse_args
    |> IO.inspect
  end
end
