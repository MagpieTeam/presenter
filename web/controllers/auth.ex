defmodule MagpiePresenter.Auth do
  import Plug.Conn
  use MagpiePresenter.Web, :controller

  def init(opts) do
  end

  def call(conn, _) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Permission NOT granted")
      |> redirect(to: "/login")
      |> halt()
    end
  end

end