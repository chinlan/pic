defmodule PicWeb.UserSocketTest do
  use PicWeb.ChannelCase

  alias PicWeb.UserSocket

  test "authenticate with valid token" do
    token = Phoenix.Token.sign(@endpoint, "user token", 123)

    assert {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert socket.assigns.current_user_id == 123
  end

  test "authenticate with invalid token" do
    assert :error = connect(UserSocket, %{"token" => "invalid token"})
    assert :error = connect(UserSocket, %{})
  end
end
