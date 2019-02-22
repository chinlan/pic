defmodule PicWeb.UserController do
  use PicWeb, :controller

  alias Pic.PicWeb
  alias Pic.PicWeb.User
  alias Pic.Repo

  # def index(conn, _params) do
  #   users = PicWeb.list_users()
  #   render(conn, "index.html", users: users)
  # end

  def new(conn, _params) do
    changeset = PicWeb.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case PicWeb.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id} = params) do
    page = params["page"] || 1
    user = PicWeb.get_user!(id) |> Repo.preload(:followers) |> Repo.preload(:followees)#|> Repo.preload(:followeds) |> Repo.preload(:follows)
    posts = PicWeb.list_posts(user, page, 5)
    render(conn, "show.html", user: user, posts: posts)
  end

  # def edit(conn, %{"id" => id}) do
  #   user = PicWeb.get_user!(id)
  #   changeset = PicWeb.change_user(user)
  #   render(conn, "edit.html", user: user, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = PicWeb.get_user!(id)

  #   case PicWeb.update_user(user, user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User updated successfully.")
  #       |> redirect(to: user_path(conn, :show, user))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", user: user, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = PicWeb.get_user!(id)
  #   {:ok, _user} = PicWeb.delete_user(user)

  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: user_path(conn, :index))
  # end
end
