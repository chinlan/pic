defmodule PicWeb.RoomChannelTest do
  use PicWeb.ChannelCase

  alias PicWeb.UserSocket
  alias PicWeb.RoomChannel
  alias Pic.PicWeb.Conversation
  alias Pic.PicWeb

  @sender_params %{
    email: "sender@example.com",
    encrypted_password: "password"
  }

  @recipient_params %{
    email: "recipient@example.com",
    encrypted_password: "password"
  }

  setup do
    {:ok, sender} = PicWeb.create_user(@sender_params)
    {:ok, recipient} = PicWeb.create_user(@recipient_params)
    {:ok, conversation} = PicWeb.find_or_create_conversation(
      %{"sender_id" => sender.id, "recipient_id" => recipient.id}
    )
    token = Phoenix.Token.sign(@endpoint, "user token", sender.id)
    {:ok, socket} = connect(UserSocket, %{"token" => token})

    {:ok, socket: socket, sender: sender, recipient: recipient, conversation: conversation}
  end

  test "assigns conversation_id to the socket after join",
    %{socket: socket, conversation: conversation} do

    {:ok, _, socket} = subscribe_and_join(socket, "room:#{conversation.id}")

    assert socket.assigns.conversation_id == "#{conversation.id}"
  end

  # setup do
  #   {:ok, _, socket} =
  #     socket("user_id", %{some: :assign})
  #     |> subscribe_and_join(RoomChannel, "room:lobby")

  #   {:ok, socket: socket}
  # end

  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push socket, "ping", %{"hello" => "there"}
  #   assert_reply ref, :ok, %{"hello" => "there"}
  # end

  # test "shout broadcasts to room:lobby", %{socket: socket} do
  #   push socket, "shout", %{"hello" => "all"}
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
