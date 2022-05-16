defmodule Blog.Posts.PostTag do
  use Ecto.Schema

  alias Blog.Posts.Post
  alias Blog.Posts.Tag

  schema "posts_tags" do
    belongs_to :post, Post
    belongs_to :tag, Tag
  end
end
