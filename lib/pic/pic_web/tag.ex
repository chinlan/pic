defmodule Pic.PicWeb.Tag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tags" do
    field :name, :string
    field :inserted_at, Ecto.DateTime
    has_many :posts_tags, Pic.PicWeb.PostsTag
    has_many :posts, through: [:posts_tags, :post]
    # many_to_many :posts, Pic.PicWeb.Post, join_through: "posts_tags"
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
