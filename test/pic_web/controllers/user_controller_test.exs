defmodule PicWeb.UserControllerTest do
  use PicWeb.ConnCase

  alias Pic.PicWeb

  test "GET /registrations/new", %{conn: conn} do
    conn = get conn, "/registrations/new"
    assert html_response(conn, 200) =~ "註冊"
  end

  @params %{
    email: "user@example.com",
    encrypted_password: "password"
  }

  test "POST /registrations", %{conn: conn} do
    conn = post conn, "/registrations", [user: @params]

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed up successfully."
    assert get_last_user().email == "user@example.com"
  end

  defp get_last_user do
    alias Pic.PicWeb.User
    import Ecto.Query

    Pic.Repo.one(from u in User, order_by: [desc: u.id], limit: 1)
  end

  test "GET /profiles/:id", %{conn: conn} do
    {:ok, user} = PicWeb.create_user(@params)
    conn = get conn, "/profiles/#{user.id}"
    assert html_response(conn, 200) =~ "個人頁面"
  end

  # @create_attrs %{email: "some email", encrypted_password: "some encrypted_password"}
  # @update_attrs %{email: "some updated email", encrypted_password: "some updated encrypted_password"}
  # @invalid_attrs %{email: nil, encrypted_password: nil}

  # def fixture(:user) do
  #   {:ok, user} = PicWeb.create_user(@create_attrs)
  #   user
  # end

  # describe "index" do
  #   test "lists all users", %{conn: conn} do
  #     conn = get conn, user_path(conn, :index)
  #     assert html_response(conn, 200) =~ "Listing Users"
  #   end
  # end

  # describe "new user" do
  #   test "renders form", %{conn: conn} do
  #     conn = get conn, user_path(conn, :new)
  #     assert html_response(conn, 200) =~ "New User"
  #   end
  # end

  # describe "create user" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post conn, user_path(conn, :create), user: @create_attrs

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == user_path(conn, :show, id)

  #     conn = get conn, user_path(conn, :show, id)
  #     assert html_response(conn, 200) =~ "Show User"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #     assert html_response(conn, 200) =~ "New User"
  #   end
  # end

  # describe "edit user" do
  #   setup [:create_user]

  #   test "renders form for editing chosen user", %{conn: conn, user: user} do
  #     conn = get conn, user_path(conn, :edit, user)
  #     assert html_response(conn, 200) =~ "Edit User"
  #   end
  # end

  # describe "update user" do
  #   setup [:create_user]

  #   test "redirects when data is valid", %{conn: conn, user: user} do
  #     conn = put conn, user_path(conn, :update, user), user: @update_attrs
  #     assert redirected_to(conn) == user_path(conn, :show, user)

  #     conn = get conn, user_path(conn, :show, user)
  #     assert html_response(conn, 200) =~ "some updated email"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, user: user} do
  #     conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #     assert html_response(conn, 200) =~ "Edit User"
  #   end
  # end

  # describe "delete user" do
  #   setup [:create_user]

  #   test "deletes chosen user", %{conn: conn, user: user} do
  #     conn = delete conn, user_path(conn, :delete, user)
  #     assert redirected_to(conn) == user_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get conn, user_path(conn, :show, user)
  #     end
  #   end
  # end

  # defp create_user(_) do
  #   user = fixture(:user)
  #   {:ok, user: user}
  # end
end
