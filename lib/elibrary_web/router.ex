defmodule ElibraryWeb.Router do
  use ElibraryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ElibraryWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElibraryWeb do
    pipe_through :browser

    live "/", BookLive.Index, :index
    live "/books", BookLive.Index, :index
    live "/books/new", BookLive.Index, :new
    live "/books/:id/edit", BookLive.Index, :edit

    live "/songs", SongLive.Index, :index
    live "/songs/new", SongLive.Index, :new
    live "/songs/:id/edit", SongLive.Index, :edit

    live "/combo", ComboLive.Index, :index
    live "/combo/new", ComboLive.Index, :new
    live "/combo/:id/edit", ComboLive.Index, :edit

    live "/labels", LabelLive.Index, :index

    live "/search", SearchLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElibraryWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ElibraryWeb.Telemetry
    end
  end
end
