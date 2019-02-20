defmodule Pic.PicWeb.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]


  schema "posts" do
    field :body, :string
    field :image, Pic.ImageUploader.Type
    #field :user_id, :id
    belongs_to :user, Pic.PicWeb.User
    has_many :comments, Pic.PicWeb.Comment

    timestamps()
  end

  @doc false
  def create_changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :image])
    |> cast_attachments(attrs, [:image])
    |> put_assoc(:user, attrs.user)
    |> validate_required([:body, :user])
  end

  def update_changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :image])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:body])
  end

  def search(query, search_term) do
    wildcard_search = "%#{search_term}"
    from post in query,
    join: user in assoc(post, :user),
    where: ilike(post.body, ^wildcard_search),
    or_where: ilike(user.email, ^wildcard_search)
  end
end
