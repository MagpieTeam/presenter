defmodule MagpiePresenter.Router do
  use MagpiePresenter.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MagpiePresenter do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/loggers/:logger_id/sensors", SensorController, :index
    get "/loggers/:logger_id/sensors/:id/batch", SensorController, :batch
    get "/loggers/:logger_id/sensors/:id/live", SensorController, :live
    get "/loggers/:logger_id/sensors/:id/batch/get_data", SensorController, :get_data
    get "/loggers", LoggerController, :index
    get "/loggers/create", LoggerController, :create
    get "/users/create", UserController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", MagpiePresenter do
  #   pipe_through :api
  # end
end
