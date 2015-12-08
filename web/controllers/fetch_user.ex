defmodule MagpiePresenter.FetchUser do
  import Plug.Conn

  def init(opts), do: nil

  def call(conn, _) do
    case get_session(conn, :user_id) do
      nil -> assign(conn, :current_user, nil)
      user_id ->
        {:ok, user} = Magpie.DataAccess.User.get(user_id)
        assign(conn, :current_user, user)
    end
  end
end