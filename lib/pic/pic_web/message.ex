defmodule Pic.PicWeb.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    belongs_to :conversation, Pic.PicWeb.Conversation
    belongs_to :user, Pic.PicWeb.User
    field :body, :string
    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :conversation_id, :user_id])
    |> validate_required([:conversation_id, :user_id])
  end
end
