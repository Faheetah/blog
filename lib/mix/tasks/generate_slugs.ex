defmodule Mix.Tasks.Blog.GenerateSlugs do
  use Mix.Task

  alias Blog.Posts
  alias Blog.Repo

  @shortdoc "Add a slug field to each post"
  def run(_) do
    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)

    Repo.start_link

    Posts.list_posts
    |> Enum.each(&add_slug/1)
  end

  defp add_slug(post) do
    Posts.update_post(post, %{"title" => post.title, "tags" => post.tags})
  end
end
