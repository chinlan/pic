defmodule Pic.PicWeb.Comment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "comments" do
    field :body, :string
    # field :post_id, :id
    # field :user_id, :id
    belongs_to :post, Pic.PicWeb.Post
    belongs_to :user, Pic.PicWeb.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
