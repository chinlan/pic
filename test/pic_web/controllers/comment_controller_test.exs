defmodule PicWeb.CommentControllerTest do
  use PicWeb.ConnCase
  use Plug.Test

  alias Pic.PicWeb

  @user_params %{
    email: "user@example.com",
    encrypted_password: "password"
  }

  @post_params %{
    body: "Post 1"
  }

  setup do
    {:ok, user} = PicWeb.create_user(@user_params)
    {:ok, post} = PicWeb.create_post(Map.put(@post_params, :user, user))
    conn = init_test_session(build_conn(), current_user_id: user.id)
    {:ok, conn: conn, user: user, post: post}
  end

  test "POST /posts/:post_id/comments", %{conn: conn, post: post} do
    conn = conn
      |> post("/posts/#{post.id}/comments", comment: %{ body: "comment 1" })

    assert redirected_to(conn) =~ "/posts/#{post.id}"
  end
end
