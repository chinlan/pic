defmodule Mix.Tasks.DeleteUselessTags do
  use Mix.Task

  import Ecto.Query

  alias Pic.PicWeb.Tag
  alias Pic.PicWeb.PostsTag
  alias Pic.Repo

  @shortdoc "Delete tags without associated posts"

  def run(_) do
    Mix.Task.run "app.start"
    query = from t in Tag,
      where: not(t.id in fragment("SELECT DISTINCT tag_id FROM posts_tags"))
    useless_tags = Repo.all(query)
    Enum.map(useless_tags, fn tag -> Repo.delete(tag) end)
  end
end
