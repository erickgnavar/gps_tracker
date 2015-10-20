defmodule GpsTracker.LocationController do
  use GpsTracker.Web, :controller
  alias GpsTracker.RethinkRepo
  alias RethinkDB.Query
  alias GpsTracker.Vehicle

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
    vehicle = Repo.get(Vehicle, vehicle_id)
    case vehicle do
      nil ->
        conn
        |> put_status(:not_found)
        |> json %{}
      _ ->
        {m, s, _} = :os.timestamp
        data = location_params
        |> Map.put_new("vehicle_id", vehicle_id)
        |> Map.put_new("inserted_at", m * 1_000_000 + s)
        Query.table("locations")
        |> Query.insert(data)
        |> RethinkRepo.run
        conn
        |> put_status(:created)
        |> json %{}
    end
  end
end
