defmodule MagpiePresenter.HomeController do
  use MagpiePresenter.Web, :controller

  def index(conn, _params) do
    router_ip = MagpiePresenter.Endpoint.config(:router_ip)

    conn
    |> assign(:router_ip, router_ip)
    |> assign(:logger, Magpie.DataAccess.Logger.get())
    |> render("index.html")
  end

end