defmodule PicWeb.PageController do
  use PicWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
