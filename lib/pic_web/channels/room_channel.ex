defmodule PicWeb.RoomChannel do
  use PicWeb, :channel

  alias Pic.PicWeb.User
  alias Pic.PicWeb
  alias Pic.Repo

  def join("room:" <> conversation_id, _payload, socket) do
    if authorized?(_payload) do
      {:ok, %{channel: "room:#{conversation_id}"}, assign(socket, :conversation_id, conversation_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("message:add", %{"body" => body} = payload, socket) do
    conversation_id =  String.to_integer(socket.assigns[:conversation_id])
    params = Map.put(payload, "user_id", socket.assigns[:current_user_id])
    params = Map.put(params, "conversation_id", conversation_id)
             |> key_to_atom
    PicWeb.create_message(params)
    user = Repo.get(User, socket.assigns[:current_user_id])
    message = %{body: body, user: %{email: user.email}}
    broadcast socket, "room:#{conversation_id}:new_message", message
    {:reply, :ok, socket}
  end

  # def handle_info(:after_join, socket) do
  #   push socket, "presence_state", Presence.list(socket)

  #   user = PicWeb.get_user!(socket.assigns.current_user_id)

  #   {:ok, _} = Presence.track(socket, "user:#{user.id}", %{typing: false, user_id: user.id})
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
