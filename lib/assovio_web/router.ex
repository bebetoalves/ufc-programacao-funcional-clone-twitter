defmodule AssovioWeb.Router do
  use AssovioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AssovioWeb.Plugs.SetCurrentUser
  end

  scope "/", AssovioWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/users/search", UserController, :search
    resources "/users", UserController, only: [:new, :create, :show]
    post "/users/:id/follow", UserController, :follow
    delete "/users/:id/unfollow", UserController, :unfollow

    resources "/sessions", SessionController, only: [:new, :create]
    delete "/sessions", SessionController, :delete

    resources "/tweets", TweetController, only: [:create]

    post "/tweets/:id/like", TweetController, :like
    delete "/tweets/:id/unlike", TweetController, :unlike
  end
end
