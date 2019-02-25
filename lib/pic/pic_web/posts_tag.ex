defmodule Pic.PicWeb.PostsTag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts_tags" do
    belongs_to :post, Pic.PicWeb.Post
    belongs_to :tag, Pic.PicWeb.Tag
    field :inserted_at, Ecto.DateTime
  end

  @doc false
  def changeset(posts_tag, attrs) do
    posts_tag
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end
end
