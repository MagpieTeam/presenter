defmodule MagpiePresenter.HomeController do
  use MagpiePresenter.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:logger, Magpie.DataAccess.Logger.get())
    |> render("index.html")
  end

end