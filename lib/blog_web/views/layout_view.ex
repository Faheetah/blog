defmodule BlogWeb.LayoutView do
  use BlogWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def registration_enabled do
    Blog.Accounts.registration_enabled
  end

  def fetch_title do
    Application.fetch_env!(:blog, :title)
  end
end
