defmodule MagpiePresenter.FecthUser do
  import Plug.Conn

  def init(opts) do
  end

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && Magpie.DataAccess.User.get(user_id)
    assign(conn, :current_user, user)
  end

  def authenticate(conn, _) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Permission NOT granted")
      |> Phoenix.Controller.redirect(to: "/login")
      |> halt()
    end
  end
end