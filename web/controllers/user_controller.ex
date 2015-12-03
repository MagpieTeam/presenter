defmodule MagpiePresenter.UserController do
  use MagpiePresenter.Web, :controller

  def create(conn, params) do
    email = params["email"]
    username = params["username"]
    password = params["password"]

    if params["state"] == "true" do
      admin = true
    else
      admin = false
    end
    if password != "" && username != "" && email != "" do

      case Magpie.DataAccess.User.put(email, username, password, admin) do
        :ok ->

          conn
          |> put_flash(:info, "bruger gemt")
          |> redirect(to: "/users")
        :error ->
          conn
          |> put_flash(:error, "Database fejl.")
          |> redirect(to: "/users/new")
      end
    else
      conn
      |> put_flash(:error, "FEJL")
      |> redirect(to: "/users/new")
    end
  end

  def index(conn, _params) do
    conn
    |> assign(:users, Magpie.DataAccess.User.get())
    |> render("index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, params) do
    IO.inspect(params["email"])
    {:ok, user} = Magpie.DataAccess.User.get(params["email"])


    conn
    |> assign(:user, user)
    |> render("show.html")
  end

  def edit(conn, params) do
    {:ok, user} = Magpie.DataAccess.User.get(params["email"])
  
    conn
    |> assign(:user, user)
    |> render("edit.html")
  end

  def delete(conn, params) do
    email = params["email"]

    case Magpie.DataAccess.User.delete(email) do
      :ok ->
        conn
        |> put_flash(:info, "bruger slettet")
        |> redirect(to: "/users")
      :error ->
        conn
        |> put_flash(:info, "database fejl")
        |> redirect(to: "/users/#{email}")
    end
  end

  def update(conn, params) do
    IO.inspect(params)
    username = params["username"]
    email = params["email"]
    password = params["password"]

    if params["state"] == "true" do
      admin = true
    else
      admin = false
    end

    if password != "" && username != "" && email != "" do

      case Magpie.DataAccess.User.put(email, username, password, admin) do
      :ok ->

        conn
        |> put_flash(:info, "Bruger opdateret")
        |> redirect(to: "/users")
      :error ->
        conn
        |> put_flash(:error, "database fejl")
        |> redirect(to: "/users/#{email}/edit")
      end
    else
      conn
      |> put_flash(:error, "fejl")
      |> redirect(to: "/users/#{email}/edit") 
    end          
  end
end