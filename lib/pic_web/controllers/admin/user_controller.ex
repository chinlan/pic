defmodule PicWeb.Admin.UserController do
  use PicWeb, :controller

  alias Pic.PicWeb
  alias Pic.PicWeb.User
  alias Pic.Auth.Authorizer

  plug :authenticate_user
  plug :authorize_admin_user

  def index(conn, params) do
    page = params["page"] || 1
    users = PicWeb.list_users(:paged, page)
    render(conn, "index.html", users: users)
  end

  def toggle_admin(conn, %{"user_id" => id, "page" => page}) do
    page = page || 1
    users = PicWeb.list_users(:paged, page)
    user = Pic.Repo.get!(User, id)
    user
    |> Ecto.Changeset.change(%{is_admin: !user.is_admin})
    |> Pic.Repo.update()

    render(conn, "index.html", users: users)
  end
end
