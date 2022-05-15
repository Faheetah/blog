defmodule BlogWeb.RSSView do
  use BlogWeb, :view

  @weekdays %{
    1 => "Mon",
    2 => "Tue",
    3 => "Wed",
    4 => "Thu",
    5 => "Fri",
    6 => "Sat",
    7 => "Sun"
  }

  @months %{
    1 => "Jan",
    2 => "Feb",
    3 => "Mar",
    4 => "Apr",
    5 => "May",
    6 => "Jun",
    7 => "Jul",
    8 => "Aug",
    9 => "Sep",
    10 => "Oct",
    11 => "Nov",
    12 => "Dec"
  }

  def format_datetime(datetime) do
    date =
      datetime
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_date

    day =
      date.day
      |> Integer.to_string
      |> String.pad_leading(2, "0")

    time =
      [datetime.hour, datetime.minute, datetime.second]
      |> Enum.map(fn t ->
        t
        |> Integer.to_string
        |> String.pad_leading(2, "0")
      end)
      |> Enum.join(":")

    "#{@weekdays[Date.day_of_week(date)]}, #{day} #{@months[date.month]} #{date.year} #{time} +0000"
  end
end
