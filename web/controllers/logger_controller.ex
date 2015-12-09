defmodule MagpiePresenter.LoggerController do
  use MagpiePresenter.Web, :controller
  import MagpiePresenter.Auth, only: [require_admin: 2]
  plug :require_admin, [route: "/"] when action in [:create, :new, :update, :edit, :delete]

  def show(conn, params) do

  {:ok, logger} = Magpie.DataAccess.Logger.get(params["logger_id"])

  conn
  #|> assign(:sensors, Magpie.DataAccess.Sensor.get("logger_id"))
  |> assign(:logger, logger)
  |> assign(:sensors, Magpie.DataAccess.Sensor.get(params["logger_id"]))
  |> render("show.html")
  end

  def index(conn, _params) do
    conn
    |> assign(:loggers, Magpie.DataAccess.Logger.get())
    |> render("index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    password =  params["password"]
    name = params["name"]

    if password != "" && name != "" do      
      
      case Magpie.DataAccess.Logger.put(name,password) do
        :ok ->

          conn
          |> put_flash(:info, "Logger gemt!")
          |> redirect(to: "/loggers")
        :error ->
          conn
          |> put_flash(:error, "Database fejl. ring for faen.")
          |> redirect(to: "/loggers/new")
      end
    else
      conn
      |> put_flash(:error, "FEJL!")
      |> redirect(to: "/loggers/new")
    end
  end

  def delete(conn, params) do
    logger = params["logger_id"]

    case Magpie.DataAccess.Logger.delete(logger) do
      :ok ->
        conn
        |> put_flash(:info, "Logger slettet")
        |> redirect(to: "/loggers")
      :error ->
        conn
        |> put_flash(:error, "database fejl. kunne ikke slette logger. ring for faen.")
        |> redirect(to: "/loggers/#{logger}")
    end
  end

  def edit(conn, params) do
    {:ok, logger} = Magpie.DataAccess.Logger.get(params["logger_id"])

    conn
    |> assign(:logger, logger)
    |> render("edit.html")
  end

  def update(conn, params) do
    name = params["name"]
    new_password = params["passwordradio"]
    logger_id = params["logger_id"]
    {:ok, logger} = Magpie.DataAccess.Logger.get(logger_id)
    IO.inspect(logger)
    password = logger[:password]

    if new_password == "true" do
      password = :uuid.uuid_to_string(:uuid.get_v4())
    end

    if password != "" && name != "" do      
      
      case Magpie.DataAccess.Logger.put(name,password,logger_id) do
        :ok ->

          conn
          |> put_flash(:info, "Logger opdateret!")
          |> redirect(to: "/loggers")
        :error ->
          conn
          |> put_flash(:error, "Database fejl. ring for faen.")
          |> redirect(to: "/loggers/#{logger_id}/edit")
      end
    else
      conn
      |> put_flash(:error, "FEJL!")
      |> redirect(to: "/loggers/#{logger_id}/edit")
    end
  end
end