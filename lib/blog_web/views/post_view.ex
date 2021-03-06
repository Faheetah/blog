defmodule BlogWeb.PostView do
  use BlogWeb, :view

  def format_markdown(content) do
    Earmark.as_html!(content)
    |> raw
  end

  def tag_input(f, label, opts) do
    if f.data.tags == %{} do
      text_input(f, label, opts)
    else
      tags = format_tags(f.data.tags)
      text_input(f, label, Keyword.put(opts, :value, tags))
    end
  end

  def format_tag_links(tags, opts \\ []) do
    tags
    |> Enum.map(fn tag ->
      link(tag.name, Keyword.put(opts, :to, Routes.post_path(BlogWeb.Endpoint, :index_for_tag, tag.name)))
    end)
    |> Enum.intersperse(" / ")
  end

  def format_tags(tags) do
    tags
    |> Enum.map(fn tag -> tag.name end)
    |> Enum.join(", ")
  end

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
