defmodule Pic.Follow do
  alias Pic.Repo

  def followee_ids(user) do
    for follow <- user.follows do
      follow.followee_id
    end
  end

  def follower_ids(user) do
    for followed <- user.followeds do
      followed.follower_id
    end
  end

  def is_following?(follower, followee) do
    Enum.member?(followee_ids(follower), followee.id)
  end

  def is_followed?(followee, follower) do
    Enum.member?(follower_ids(followee), follower.id)
  end
end
