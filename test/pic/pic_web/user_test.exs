defmodule Pic.PicWeb.UserTest do
  use Pic.DataCase, async: true

  alias Pic.PicWeb.User
  alias Pic.PicWeb
  alias Pic.Repo

  describe "User.changeset/2" do
    @invalid_attrs %{}

    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end

    @valid_attrs %{
      email: "user@example.com",
      encrypted_password: "password"
    }

    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end
  end

  describe "User.name/1" do
    @valid_attrs %{
      email: "user@example.com",
      encrypted_password: "password"
    }
    test "get username from email" do
      {:ok, user} = PicWeb.create_user(@valid_attrs)
      user = Repo.get!(User, user.id)
      name = User.name(user)
      assert name ="user"
    end
  end
end
