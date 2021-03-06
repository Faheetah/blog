defmodule BlogWeb.Router do
  use BlogWeb, :router

  import BlogWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BlogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :put_title
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogWeb do
    pipe_through :browser

    get "/", PostController, :index
  end

  ## Authentication routes

  scope "/", BlogWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", BlogWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/posts/new", PostController, :new
    post "/posts", PostController, :create
    get "/posts/:slug/edit", PostController, :edit
    put "/posts/:slug", PostController, :update
    delete "/posts/:slug", PostController, :delete
  end

  scope "/", BlogWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/posts", PostController, :index
    get "/tags/:tag", PostController, :index_for_tag
    get "/posts/:slug", PostController, :show
  end

  scope "/", BlogWeb do
    get "/rss", RSSController, :index
  end

  def put_title(conn, _params) do
    assign(conn, :title, Application.fetch_env!(:blog, :title))
  end
end
