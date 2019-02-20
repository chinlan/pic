defmodule PicWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import PicWeb.Router.Helpers

  alias Pic.PicWeb

  def authenticate_user(conn, _args) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page.")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  def authorize_admin_user(conn, _params) do
    if conn.assigns.current_user.is_admin == true do
      conn
    else
      conn
      |> put_flash(:error, "You need admin identity to continue.")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
