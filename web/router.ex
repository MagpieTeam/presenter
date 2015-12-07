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
    
    get "/loggers/:logger_id/sensors/:id/batch", SensorController, :batch
    get "/loggers/:logger_id/sensors/:id/live", SensorController, :live
    get "/loggers/:logger_id/sensors/:id/batch/get_data", SensorController, :get_data

    get "/loggers", LoggerController, :index
    get "/loggers/new", LoggerController, :new
    get "/loggers/:logger_id/", LoggerController, :show
    get "/loggers/:logger_id/edit", LoggerController, :edit
    delete "/loggers/:logger_id", LoggerController, :delete
    post "/loggers/create", LoggerController, :create
    put "/loggers/:logger_id/update", LoggerController, :update

    get "/users", UserController, :index
    get "/users/new", UserController, :new
    get "/users/:id", UserController, :show
    get "/users/:id/edit", UserController, :edit
    delete "/users/:id", UserController, :delete
    post "/users/create", UserController, :create
    put "/users/:id/update", UserController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", MagpiePresenter do
  #   pipe_through :api
  # end
end
