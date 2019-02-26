defmodule Pic.Email do
  use Bamboo.Phoenix, view: PicWeb.MailView

  import PicWeb.Gettext
  alias Pic.PicWeb.User

  def hello_email(email) do
    new_email
    |> to(email)
    |> from("no-reply@pic.com")
    |> subject("Welcome!")
    |> text_body("Welcome to My App!!")
  end

  def notify_follow_text_email(user, follower) do
    user_name = User.name(user)
    follower_name = User.name(follower)
    new_email
    |> to(user.email)
    |> from("no-reply@pic.com")
    |> subject(gettext("You have a new follower!"))
    |> assign(:user, user_name)
    |> assign(:follower, follower_name)
    |> put_text_layout({PicWeb.LayoutView, "email.text"})
    |> render("notify_follow.text")
  end

  def notify_follow_html_email(user, follower) do
    notify_follow_text_email(user, follower)
    |> put_html_layout({PicWeb.LayoutView, "email.html"})
    |> render("notify_follow.html")
  end
end
