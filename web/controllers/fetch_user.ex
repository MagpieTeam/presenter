defmodule MagpiePresenter.FetchUser do
  import Plug.Conn

  def init(opts), do: nil

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    user = user_id && Magpie.DataAccess.User.get(user_id)
    assign(conn, :current_user, user)
  end
end