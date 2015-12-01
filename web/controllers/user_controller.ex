defmodule MagpiePresenter.UserController do
  use MagpiePresenter.Web, :controller

  def create(conn, _params) do
    render(conn, "create.html")
  end
end