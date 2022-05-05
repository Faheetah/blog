defmodule Blog.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Blog.Repo

  alias Blog.Accounts.User
  alias Blog.Posts.Post
  alias Blog.Posts.PostTag
  alias Blog.Posts.Tag

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(from p in Post, order_by: [desc: p.inserted_at], preload: [:tags, :user])
  end

  @doc """
  Lists posts by tag.
  """
  def list_posts_for_tag(name) do
    Repo.all(
      from t in Tag,
      where: t.name == ^name,
      join: pt in PostTag,
      on: pt.tag_id == t.id,
      join: p in Post,
      on: pt.post_id == p.id,
      order_by: [desc: p.inserted_at],
      select: p
    )
    |> Repo.preload([:tags, :user])
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload([:tags, :user])
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    post
    |> Repo.preload(:tags)
    |> Post.changeset(attrs)
  end

  def insert_or_get_tags([]) do
    []
  end

  def insert_or_get_tags(names) do
    Repo.insert_all(
      Tag,
      Enum.map(names, &%{name: &1}),
      on_conflict: :nothing
    )

    Repo.all(from t in Tag, where: t.name in ^names)
  end


end
