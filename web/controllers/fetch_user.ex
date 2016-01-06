defmodule MagpiePresenter.FetchUser do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: nil

  def call(conn, _) do
    case get_session(conn, :user_id) do
      nil -> assign(conn, :current_user, nil)
      user_id ->
        case Magpie.DataAccess.User.get(user_id) do
          {:ok, user} -> assign(conn, :current_user, user)
          _ ->  conn    
                |> delete_session(:user_id)
                |> put_flash(:error, "Denne bruger eksisterer ikke.")
                |> redirect(to: "/login")
        end
    end
  end
end