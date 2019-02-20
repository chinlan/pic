defmodule PicWeb.Helpers.TimeFormatter do
  use Timex

  def default_format(time) do
    Timex.format!(time, "%Y/%M/%D %H:%m", :strftime)
  end
end
