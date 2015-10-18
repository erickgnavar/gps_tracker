defmodule GpsTracker.LocationController do
  use GpsTracker.Web, :controller
  alias GpsTracker.RethinkRepo
  alias RethinkDB.Query
  require Logger

  def index(conn, %{"vehicle_id" => vehicle_id}) do
    vehicle_id = String.to_integer vehicle_id
    locations = Query.table("locations")
    |> Query.filter(%{vehicle_id: vehicle_id})
    |> RethinkRepo.run
    json conn, locations
  end

  def create(conn, %{"vehicle_id" => vehicle_id, "location" => location_params}) do
    # TODO: find a way to check vehicle_id in router
    vehicle_id = String.to_integer vehicle_id
    data = location_params
    |> Map.put_new "vehicle_id", vehicle_id
    Query.table("locations")
    |> Query.insert(data)
    |> RethinkRepo.run
    conn
    |> put_status(:created)
    |> json %{}
  end
end
