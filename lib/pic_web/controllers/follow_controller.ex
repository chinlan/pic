defmodule PicWeb.FollowController do
  use PicWeb, :controller

  alias Pic.PicWeb

  plug :authenticate_user

  def create(conn, follow_params) do
    current_user = conn.assigns.current_user
    user_id = follow_params["followee_id"]
    params = Map.put(follow_params, "follower_id", current_user.id)
    params = Map.put(params, "followee_id", user_id)
    case PicWeb.create_follow(params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: user_path(conn, :show, user_id))
      {:error, %Ecto.Changeset{} = changeset} ->
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
