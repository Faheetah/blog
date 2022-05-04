defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Posts
  alias Blog.Posts.Tag

  schema "posts" do
    field :content, :string
    field :preview, :string
    field :title, :string
    many_to_many :tags, Tag, join_through: "posts_tags", on_replace: :delete
    field :tag_list, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    IO.inspect attrs
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
    |> generate_preview(attrs)
    |> trim_content(attrs)
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp trim_content(post, %{"content" => content}) do
    put_change(post, :content, String.trim(content))
  end
  defp trim_content(post, _attrs), do: post

  # if preview is under 255 characters, then content will render instead
  # and preview will be null
  defp generate_preview(post, %{"content" => <<preview::binary-size(255), _::binary>>}) do
    put_change(post, :preview, preview)
  end
  defp generate_preview(post, _), do: post

  defp parse_tags(%{"tag_list" => tags}) do
    tags
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Posts.insert_or_get_tags()
  end
  defp parse_tags(_attrs), do: []
end
