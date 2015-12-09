defmodule MagpiePresenter.UserController do
  use MagpiePresenter.Web, :controller
  import MagpiePresenter.Auth, only: [require_admin: 2]
  plug :require_admin, [route: "/"] when action in [:create, :new, :index, :delete]

  def create(conn, params) do
    email = params["email"]
    username = params["username"]
    password = params["password"]
    IO.inspect(email)
    IO.inspect(username)
    IO.inspect(password)

    if params["state"] == "on" do
      admin = true
    else
      admin = false
    end

    IO.inspect(admin)
    if password != "" && username != "" && email != "" do
      password = Magpie.Password.hash_password(password)

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
    IO.inspect(params["id"])
    {:ok, user} = Magpie.DataAccess.User.get(params["id"])

    conn
    |> assign(:user, user)
    |> render("show.html")
  end

  def edit(conn, params) do
    {:ok, user} = Magpie.DataAccess.User.get(params["id"])
  
    conn
    |> assign(:user, user)
    |> render("edit.html")
  end

  def delete(conn, params) do
    id = params["id"]

    case Magpie.DataAccess.User.delete(id) do
      :ok ->
        conn
        |> put_flash(:info, "bruger slettet")
        |> redirect(to: "/users")
      :error ->
        conn
        |> put_flash(:info, "database fejl")
        |> redirect(to: "/users/#{id}")
    end
  end

  def update(conn, params) do
    username = params["username"]
    email = params["email"]
    password = params["password"]
    id = params["id"]
    
    if params["state"] == "on" do
      admin = true
    else
      admin = false
    end

    if username != "" && email != "" do
      if password == "" do
        {:ok, user} = Magpie.DataAccess.User.get(id)
        password = user[:password]
      else
        password = Magpie.Password.hash_password(password)
      end

      case Magpie.DataAccess.User.put(email, username, password, admin, id) do
      :ok ->

        conn
        |> put_flash(:info, "Bruger opdateret")
        |> redirect(to: "/users/#{id}")
      :error ->
        conn
        |> put_flash(:error, "database fejl")
        |> redirect(to: "/users/#{id}/edit")
      end
    else
      conn
      |> put_flash(:error, "fejl")
      |> redirect(to: "/users/#{id}/edit") 
    end          
  end
end