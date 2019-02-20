defmodule Pic.PicWeb.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :is_admin, :boolean
    has_many :posts, Pic.PicWeb.Post
    has_many :comments, Pic.PicWeb.Comment
    has_many :followeds, Pic.PicWeb.Follow, foreign_key: :followee_id
    has_many :followers, through: [:followeds, :follower]
    has_many :follows, Pic.PicWeb.Follow, foreign_key: :follower_id
    has_many :followees, through: [:follows, :followee]
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> validate_required([:email, :encrypted_password])
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
