defmodule Pic.PicWeb.Follow do
  use Ecto.Schema
  import Ecto.Changeset


  schema "follows" do
    belongs_to :followee, Pic.PicWeb.User, foreign_key: :followee_id
    belongs_to :follower, Pic.PicWeb.User, foreign_key: :follower_id

    field :inserted_at, Ecto.DateTime
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:followee_id, :follower_id])
    |> validate_required([:followee_id, :follower_id])
  end
end
