defmodule BlogWeb.PostView do
  use BlogWeb, :view

  @days %{1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July", 8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December"}

  def format_datetime(datetime) do
    "#{@days[datetime.month]} #{inflex(datetime.day)}, #{datetime.year}"
  end

  defp inflex(1), do: "1st"
  defp inflex(2), do: "2nd"
  defp inflex(3), do: "3nd"
  # 4th 5th 6th 7th 8th 9th 10th
  # 11th 12th 13th 14th 15th 16th 17th 18th 19th 20th
  defp inflex(21), do: "21st"
  defp inflex(22), do: "22nd"
  defp inflex(23), do: "23rd"
  # 24th 25th 26th 27th 28th 29th 30th
  defp inflex(31), do: "31st"
  defp inflex(n), do: "#{n}th"
end
