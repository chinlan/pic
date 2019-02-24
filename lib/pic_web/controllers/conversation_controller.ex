defmodule PicWeb.ConversationController do
  use PicWeb, :controller

  alias Pic.PicWeb
  alias Pic.Repo
  alias Pic.PicWeb.Conversation

  plug :authenticate_user

  def show(conn, %{"id" => id}) do
    conversation = Conversation
                  |> Repo.get(id)
                  |> Repo.preload(:sender)
                  |> Repo.preload(:recipient)
                  |> Repo.preload(messages: :user)
    render(conn, "show.html", conversation: conversation)
  end

  def create(conn, conversation_params) do
    current_user = conn.assigns.current_user
    user_id = conversation_params["recipient_id"]
    params = Map.put(conversation_params, "sender_id", current_user.id)
    params = Map.put(params, "recipient_id", user_id)
    case PicWeb.find_or_create_conversation(params) do
      {:ok, conversation} ->
        conn
        |> redirect(to: conversation_path(conn, :show, conversation))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Something went wrong.")
        |> redirect(to: user_path(conn, :show, user_id))
    end
  end
end
