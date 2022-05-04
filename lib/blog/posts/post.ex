defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :preview, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
    |> generate_preview(attrs)
  end

  defp trim_content(post, %{"content" => content}) do
    put_change(post, :content, String.trim(content))
  end

  defp generate_preview(post, %{"content" => <<preview::binary-size(255), _::binary>>}) do
    put_change(post, :preview, preview)
  end
  defp generate_preview(post, _), do: post
end
