defmodule PicWeb.PostControllerTest do
  use PicWeb.ConnCase
  use Plug.Test

  alias Pic.PicWeb

  test "GET /posts", %{conn: conn} do
    conn = get conn, "/posts", [page: 1, per_page: 3, query: nil]
    assert html_response(conn, 200) =~ "圖文列表"
  end

  @user_params %{
    email: "user@example.com",
    encrypted_password: "password"
  }

  @post_params %{
    body: "Post 1"
  }

  test "POST /posts", %{conn: conn} do
    {:ok, user} = PicWeb.create_user(@user_params)
    conn = conn
      |> init_test_session(%{current_user_id: user.id})
      |> post("/posts", post: @post_params)

    assert redirected_to(conn) =~ "/posts"
  end
end
