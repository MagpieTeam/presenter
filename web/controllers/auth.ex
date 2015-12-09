defmodule MagpiePresenter.Auth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: nil

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

  def require_admin(conn, opts) do
    if conn.assigns.current_user[:admin] do
      conn
    else
      conn
      |> put_flash(:error, "Only admin")
      |> redirect(to: opts[:route])
      |> halt()
    end
  end

end