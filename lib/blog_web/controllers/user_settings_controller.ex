defmodule BlogWeb.UserSettingsController do
  use BlogWeb, :controller

  alias Blog.Accounts
  alias BlogWeb.UserAuth

  plug :assign_username_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_username"} = params) do
  %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_username(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Username updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", username_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  defp assign_username_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:username_changeset, Accounts.change_user_username(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
