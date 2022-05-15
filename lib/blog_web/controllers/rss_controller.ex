defmodule BlogWeb.RSSController do
  use BlogWeb, :controller

  alias Blog.Posts

  plug :put_layout, false

  def index(conn, _params) do
    posts = Posts.list_rss_posts()
    vars = [
      title: Application.fetch_env!(:blog, :title),
      description: Application.fetch_env!(:blog, :description),
      url: "#{conn.scheme}://#{conn.host}:#{conn.port}",
      posts: posts,
      last_build_date: maybe_get_first_post_date(posts)
    ]

    render(conn, "index.xml", vars)
  end

  defp maybe_get_first_post_date([]), do: DateTime.now!("Etc/UTC")
  defp maybe_get_first_post_date(posts), do: hd(posts).inserted_at
end
