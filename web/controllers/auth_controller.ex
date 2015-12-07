defmodule MagpiePresenter.AuthController do
  use MagpiePresenter.Web, :controller

  def new(conn, params) do


    render(conn, "login.html")
  end

  def create(conn, params) do
    email = params["email"]
    password = params["password"]

    case Magpie.DataAccess.User.get_by_email(email) do
      {:ok, user} ->
        if Magpie.Password.verify_password(password, user[:password]) do
          conn
          |> put_flash(:info, "Davs mester")
          |> put_session(:user_id, user[:id])
          |> redirect(to: "/loggers")
        else
          conn
          |> put_flash(:error, "Forkert email og password for søren!")
          |> render("login.html")
        end

      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("login.html")

    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Tak for denne gang! logget ud!")
    |> redirect(to: "/login")
  end
end