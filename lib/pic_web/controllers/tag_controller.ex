defmodule PicWeb.TagController do
  use PicWeb, :controller

  alias Pic.PicWeb

  def show(conn, %{"tag" => tag_name}) do
    tag = PicWeb.get_tag(tag_name)
    render(conn, "show.html", tag: tag)
  end
end
