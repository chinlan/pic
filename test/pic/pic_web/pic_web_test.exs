defmodule Pic.PicWebTest do
  use Pic.DataCase, async: true

  alias Pic.PicWeb
  alias Pic.Repo
  alias Pic.PicWeb.User

  describe "PicWeb.create_user/1" do
    @valid_attrs %{
      email: "user@example.com",
      encrypted_password: "password"
    }

    test "changeset with non-unique email" do
      PicWeb.create_user(@valid_attrs)

      {:error, changeset} = PicWeb.create_user(@valid_attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "all attributes are saved properly" do
      {:ok, user} = PicWeb.create_user(@valid_attrs)
      user = Repo.get!(User, user.id)

      assert Comeonin.Bcrypt.checkpw(@valid_attrs[:encrypted_password], user.encrypted_password)
      assert user.email == @valid_attrs[:email]
    end
  end

  # describe "users" do
  #   alias Pic.PicWeb.User

  #   @valid_attrs %{email: "some email", encrypted_password: "some encrypted_password"}
  #   @update_attrs %{email: "some updated email", encrypted_password: "some updated encrypted_password"}
  #   @invalid_attrs %{email: nil, encrypted_password: nil}

  #   def user_fixture(attrs \\ %{}) do
  #     {:ok, user} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> PicWeb.create_user()

  #     user
  #   end

  #   test "list_users/0 returns all users" do
  #     user = user_fixture()
  #     assert PicWeb.list_users() == [user]
  #   end

  #   test "get_user!/1 returns the user with given id" do
  #     user = user_fixture()
  #     assert PicWeb.get_user!(user.id) == user
  #   end

  #   test "create_user/1 with valid data creates a user" do
  #     assert {:ok, %User{} = user} = PicWeb.create_user(@valid_attrs)
  #     assert user.email == "some email"
  #     assert user.encrypted_password == "some encrypted_password"
  #   end

  #   test "create_user/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = PicWeb.create_user(@invalid_attrs)
  #   end

  #   test "update_user/2 with valid data updates the user" do
  #     user = user_fixture()
  #     assert {:ok, user} = PicWeb.update_user(user, @update_attrs)
  #     assert %User{} = user
  #     assert user.email == "some updated email"
  #     assert user.encrypted_password == "some updated encrypted_password"
  #   end

  #   test "update_user/2 with invalid data returns error changeset" do
  #     user = user_fixture()
  #     assert {:error, %Ecto.Changeset{}} = PicWeb.update_user(user, @invalid_attrs)
  #     assert user == PicWeb.get_user!(user.id)
  #   end

  #   test "delete_user/1 deletes the user" do
  #     user = user_fixture()
  #     assert {:ok, %User{}} = PicWeb.delete_user(user)
  #     assert_raise Ecto.NoResultsError, fn -> PicWeb.get_user!(user.id) end
  #   end

  #   test "change_user/1 returns a user changeset" do
  #     user = user_fixture()
  #     assert %Ecto.Changeset{} = PicWeb.change_user(user)
  #   end
  # end
end
