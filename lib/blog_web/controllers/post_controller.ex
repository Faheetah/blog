defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Posts
  alias Blog.Posts.Post

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def index_for_tag(conn, %{"tag" => name}) do
    tag = String.downcase(name)
    posts = Posts.list_posts_for_tag(tag)
    render(conn, "index.html", posts: posts, tag: tag)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(Map.put(post_params, "user_id", conn.assigns.current_user.id)) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    post = Posts.get_post_by_slug!(slug)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"slug" => slug}) do
    post = Posts.get_post_by_slug!(slug)
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"slug" => slug, "post" => post_params}) do
    post = Posts.get_post_by_slug!(slug)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    post = Posts.get_post_by_slug!(slug)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
