defmodule MagpiePresenter.PageController do
  use MagpiePresenter.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
