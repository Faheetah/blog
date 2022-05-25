defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Accounts.User
  alias Blog.Posts
  alias Blog.Posts.Tag

  @derive {Phoenix.Param, key: :slug}
  schema "posts" do
    field :content, :string
    field :preview, :string
    field :title, :string
    field :slug, :string
    many_to_many :tags, Tag, join_through: "posts_tags", on_replace: :delete
    belongs_to :user, User
    field :tag_list, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id, :slug])
    |> validate_required([:title, :content])
    |> generate_preview(attrs)
    |> generate_slug(attrs)
    |> trim_content(attrs)
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp trim_content(post, %{"content" => content}) do
    put_change(post, :content, String.trim(content))
  end
  defp trim_content(post, _attrs), do: post

  # if preview is under 255 characters, then content will render instead
  # and preview will be null
  defp generate_preview(post, %{"content" => content}) do
    preview =
      content
      |> String.split("\n")
      |> Enum.map(fn c -> String.trim_trailing(c, "\r") end)
      |> Enum.reject(fn c -> String.starts_with?(c, "#") || c == "" end)
      |> hd
      |> truncate_preview

    put_change(post, :preview, preview)
  end
  defp generate_preview(post, %{}), do: post

  defp truncate_preview(<<preview::binary-size(255), _::binary>>) do
    preview
  end
  defp truncate_preview(content), do: content

  defp generate_slug(post, %{"title" => title}) do
    slug =
      title
      |> String.replace(~r/[[:punct:]]/u, "")
      |> String.replace(" ", "-")
      |> String.downcase()

    put_change(post, :slug, slug)
  end
  defp generate_slug(post, %{}) do
    post
  end

  defp parse_tags(%{"tag_list" => tags}) do
    tags
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.reject(& &1 == "")
    |> Posts.insert_or_get_tags()
  end
  defp parse_tags(%{"tags" => tags}) do
    tags
  end
  defp parse_tags(_attrs), do: []
end
