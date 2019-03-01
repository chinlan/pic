defmodule Pic.PicWeb do
  @moduledoc """
  The PicWeb context.
  """

  import Ecto.Query, warn: false
  alias Pic.Repo

  alias Pic.PicWeb.User
  alias Pic.PicWeb.Post
  alias Pic.PicWeb.Comment
  alias Pic.PicWeb.Follow
  alias Pic.PicWeb.Conversation
  alias Pic.PicWeb.Message
  alias Pic.PicWeb.Tag
  alias Pic.PicWeb.PostsTag
  alias Pic.Pagination

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users(a, page \\ 1, per_page \\ 5)

  def list_users(:paged, page, per_page) do
    User
    |> order_by(desc: :inserted_at)
    |> Pagination.page([], page, per_page: per_page)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_by_email(email) when is_nil(email) do
    nil
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def list_posts do
    Repo.all(Post) |> Repo.preload(:user)
  end

  def list_posts(user = %User{}) do
    Post
    |> where(user_id: ^user.id)
    |> Repo.all
  end

  def list_posts(a, page \\ 1, per_page \\ 5, query \\ nil)

  def list_posts(:paged, page, per_page, query) do
    Post
    |> Post.search(query)
    |> order_by(desc: :inserted_at)
    |> Pagination.page([:user], page, per_page: per_page)
  end

  def list_posts(user = %User{}, page, per_page, _query) do
    Post
    |> where(user_id: ^user.id)
    |> order_by(desc: :inserted_at)
    |> Pagination.page([:user], page, per_page: per_page)
  end

  def get_post!(id) do
   Post
     |> Repo.get(id)
     |> Repo.preload(:comments)
     |> Repo.preload(:user)
     |> Repo.preload(:tags)
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%User{} = user, %Post{} = post) do
    Post.create_changeset(post, %{user: user})
  end

  def edit_change_post(%Post{} = post) do
    Post.update_changeset(post, %{})
  end

  def create_follow(attrs \\ %{}) do
    %Follow{}
    |> Follow.changeset(attrs)
    |> Repo.insert()
  end

  def delete_follow(followee_id) do
    Repo.get_by!(Follow, followee_id: followee_id)
    |> Repo.delete()
  end

  def find_or_create_conversation(attrs \\ %{}) do
    case existed_conversation(attrs) do
      [] -> %Conversation{sender_id: attrs["sender_id"], recipient_id: attrs["recipient_id"]}
      [conversation] -> conversation
    end
    |> Conversation.changeset(attrs)
    |> Repo.insert_or_update
  end

  defp existed_conversation(attrs \\ %{}) do
    recipient_id =
      if is_binary(attrs["recipient_id"]) do
        String.to_integer(attrs["recipient_id"])
      else
        attrs["recipient_id"]
      end
    sender_id = attrs["sender_id"]
    query = from c in Conversation,
            where: c.sender_id in [^sender_id, ^recipient_id],
            where: c.recipient_id in [^recipient_id, ^sender_id]
    Repo.all(query)
  end

  def create_message(attrs \\ %{}) do
     %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def add_tag(post, tag_name) when is_binary(tag_name) do
    tag =
      case Repo.get_by(Tag, %{name: tag_name}) do
        nil ->
          %Tag{} |> Tag.changeset(%{name: tag_name}) |> Repo.insert!()
        tag ->
          tag
      end
    add_tag(post, tag.id)
  end

  def add_tag(%Post{} = post, tag_id) do
    add_tag(post.id, tag_id)
  end

  def add_tag(post_id, tag_id) do
    PostsTag.changeset(%PostsTag{}, %{post_id: post_id, tag_id: tag_id})
    |> Repo.insert()
  end

  def remove_tag(post, tag_name) when is_binary(tag_name) do
    case Repo.get_by(Tag, %{name: tag_name}) do
      nil -> nil
      tag -> remove_tag(post, tag.id)
    end
  end

  def remove_tag(%Post{} = post, tag_id) do
    remove_tag(post.id, tag_id)
  end

  def remove_tag(post_id, tag_id) do
    case Repo.get_by(PostsTag, %{ post_id: post_id, tag_id: tag_id}) do
      nil -> nil
      posts_tag -> Repo.delete(posts_tag)
    end
  end

  def tags_loaded(%{tags: tags}) do
    tags |> Enum.map_join(", ", &(&1.name))
  end

  def update_tags(post, new_tags) when is_binary(new_tags) do
    old_tags = tags_loaded(post) |> String.split(", ")
    new_tags = new_tags |> String.split(", ")
    Enum.each(new_tags -- old_tags, &add_tag(post, &1))
    Enum.each(old_tags -- new_tags, &remove_tag(post, &1))
  end

  def get_tag(tag_name) do
    Tag |> Repo.get_by(name: tag_name) |> Repo.preload(:posts)
  end
end
