defmodule Pic.PicWeb.Conversation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "conversations" do
    belongs_to :sender, Pic.PicWeb.User, foreign_key: :sender_id
    belongs_to :recipient, Pic.PicWeb.User, foreign_key: :recipient_id
    has_many :messages, Pic.PicWeb.Message
    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:sender_id, :recipient_id])
    |> validate_required([:sender_id, :recipient_id])
  end
end
