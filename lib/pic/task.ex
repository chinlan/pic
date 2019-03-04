defmodule Pic.Task do
  import Ecto.Query

  alias Pic.PicWeb.Tag
  alias Pic.PicWeb.PostsTag
  alias Pic.Repo

  def delete_useless_tags do
    query = from t in Tag,
      where: not(t.id in fragment("SELECT DISTINCT tag_id FROM posts_tags"))
    useless_tags = Repo.all(query)
    Enum.map(useless_tags, fn tag -> Repo.delete(tag) end)
  end
end
