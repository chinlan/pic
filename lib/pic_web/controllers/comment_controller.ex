defmodule PicWeb.CommentController do
  use PicWeb, :controller

  alias Pic.PicWeb
  alias Pic.PicWeb.Post
  alias Pic.Repo

  plug :authenticate_user when action in [:create]


  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    current_user = conn.assigns.current_user
    post = Repo.get(Post, post_id)
    comment_changeset = Ecto.build_assoc(post, :comments, body: comment_params["body"], user_id: current_user.id)
    Repo.insert(comment_changeset)

    conn
    |> put_flash(:info, "Comment created successfully.")
    |> redirect(to: post_path(conn, :show, post))
  end
end
