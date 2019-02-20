defmodule PicWeb.LayoutView do
  use PicWeb, :view

  def toggle_locale(conn, locale, language_title, class) do
    "<a class=\"#{class}\" href=\"#{Phoenix.Controller.current_path(conn, locale: locale)}\">#{language_title}</a>" |> raw
  end
end
