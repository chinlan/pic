defmodule Pic.Auth.Authorizer do
  def can_manage?(user, obj) do
    user && user.id == obj.user_id
  end

  def is_admin?(user) do
    user.is_admin == true
  end
end
