defmodule PicWeb.MailController do
  use PicWeb, :controller

  alias Pic.Mailer

  def index(conn, _params) do
    Pic.Email.hello_email("nilsoul@hotmail.com.tw")
      |> Mailer.deliver_now
    redirect(conn, to: post_path(conn, :index))
  end
end
