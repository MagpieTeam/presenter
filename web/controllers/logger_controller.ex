defmodule MagpiePresenter.LoggerController do
  use MagpiePresenter.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:loggers, Magpie.DataAccess.Logger.get())
    |> render("loggers.html")
  end

  def create(conn, _params) do
    render(conn, "create.html")
  end
end