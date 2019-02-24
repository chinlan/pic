defmodule PicWeb.Router do
  use PicWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PicWeb.SetCurrentUser
    plug PicWeb.SetLocale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PicWeb do
    pipe_through :browser # Use the default browser stack

    #get "/", PageController, :index
    get "/", PostController, :index
    resources "/posts", PostController do
      resources "/comments", CommentController, only: [:create]
    end
    resources "/registrations", UserController, only: [:create, :new]
    resources "/profiles", UserController, only: [:show]
    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete
    post "/follow", FollowController, :create
    delete "/unfollow", FollowController, :delete
    #get "/chat", ChatController, :index
    resources "/conversations", ConversationController, only: [:show, :create]
  end

  scope "/admin", PicWeb, as: :admin do
    pipe_through :browser
    get "/", Admin.HomeController, :index
    resources "/user", Admin.UserController do
      get "/toggle_admin", Admin.UserController, :toggle_admin, as: :toggle_admin
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PicWeb do
  #   pipe_through :api
  # end
end
