defmodule GpsTracker.LocationController do
  use GpsTracker.Web, :controller
  alias GpsTracker.Location

  def index(conn, %{"vehicle_id" => vehicle_id}) do
    locations = Repo.all from l in Location, where: l.vehicle_id == ^vehicle_id
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"vehicle_id" => vehicle_id, "location" => location_params}) do
    location_params = Map.put(location_params, "vehicle_id", vehicle_id)
    changeset = Location.changeset(%Location{}, location_params)
    case Repo.insert(changeset) do
      {:ok, location} ->
        data = GpsTracker.LocationView.render("location.json", %{location: location})
        GpsTracker.Endpoint.broadcast("tracking:home", "new_location", data)
        conn
        |> put_status(:created)
        |> render("show.json", location: location)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(GpsTracker.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
