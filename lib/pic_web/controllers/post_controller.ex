defmodule PicWeb.PostController do
  use PicWeb, :controller

  alias Pic.PicWeb
  alias Pic.PicWeb.{Post, Comment}
  alias Pic.Auth.Authorizer

  plug :authenticate_user when action in [:new, :create, :edit, :update, :delete]
  plug :authorize_user when action in [:edit, :update, :delete]

  def index(conn, params) do
    page = params["page"] || 1
    posts = PicWeb.list_posts(:paged, page, 3, params["query"])
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = PicWeb.change_post(conn.assigns.current_user, %Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user
    # changeset = Ecto.build_assoc(current_user, :posts, body: post_params["body"])
    # case Repo.insert(changeset) do
    post_params = post_params |> key_to_atom
    params = Map.put(post_params, :user, current_user)
    case PicWeb.create_post(params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = PicWeb.get_post!(id)
    comment_changeset = Comment.changeset(%Comment{}, %{})
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = PicWeb.get_post!(id)
    tags = PicWeb.tags_loaded(post)
    changeset = PicWeb.edit_change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, tags: tags)
  end

  def update(conn, %{"id" => id, "post" => %{"tags" => tags} = post_params}) do
    post = PicWeb.get_post!(id)
    PicWeb.update_tags(post, tags)

    case PicWeb.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = PicWeb.get_post!(id)
    {:ok, _post} = PicWeb.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  defp authorize_user(conn, _params) do
    %{params: %{"id" => id}} = conn
    post = PicWeb.get_post!(id)
    if Authorizer.can_manage?(conn.assigns.current_user, post) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to access that page")
      |> redirect(to: post_path(conn, :index))
      |> halt()
    end
  end
end
