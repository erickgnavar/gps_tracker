defmodule GpsTracker.Router do
  use GpsTracker.Web, :router

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

  scope "/", GpsTracker do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/register/", RegistrationController, :new
    post "/register/", RegistrationController, :create
    get "/login/", SessionController, :new
    post "/login/", SessionController, :create
    delete "/login/", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api", GpsTracker do
    pipe_through :api
    get "/vehicles/:vehicle_id/locations/", LocationController, :index
    post "/vehicles/:vehicle_id/locations/", LocationController, :create
  end
end
