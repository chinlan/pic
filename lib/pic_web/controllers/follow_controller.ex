defmodule PicWeb.FollowController do
  use PicWeb, :controller

  alias Pic.PicWeb
  alias Pic.Email
  alias Pic.Mailer

  plug :authenticate_user

  def create(conn, follow_params) do
    current_user = conn.assigns.current_user
    user_id = follow_params["followee_id"]
    params = Map.put(follow_params, "follower_id", current_user.id)
    params = Map.put(params, "followee_id", user_id)
    case PicWeb.create_follow(params) do
      {:ok, _follow} ->
        user = PicWeb.get_user!(user_id)
        Email.notify_follow_html_email(user, current_user)
        |> Mailer.deliver_later()
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: user_path(conn, :show, user_id))

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:info, "Something went wrong.")
        |> redirect(to: user_path(conn, :show, user_id))
    end
  end

  def delete(conn, %{"followee_id" => id}) do
    {:ok, _post} = PicWeb.delete_follow(id)

    conn
    |> put_flash(:info, "Follow cancelled successfully.")
    |> redirect(to: user_path(conn, :show, id))
  end
end
