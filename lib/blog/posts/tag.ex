defmodule Blog.Posts.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Posts.Post

  schema "tags" do
    field :name, :string
    many_to_many :posts, Post, join_through: "posts_tags", on_replace: :delete
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
