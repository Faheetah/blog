defmodule Blog.Posts.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Posts.Post
  alias Blog.Posts.Tag

  schema "posts_tags" do
    belongs_to :posts, Post
    belongs_to :tags, Tag
  end
end
