defmodule GpsTracker.LocationView do
  use GpsTracker.Web, :view

  def render("index.json", %{locations: locations}) do
    %{data: render_many(locations, GpsTracker.LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, GpsTracker.LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{
      id: location.id,
      latitude: location.latitude,
      longitude: location.longitude,
      vehicle_id: location.vehicle_id,
      inserted_at: location.inserted_at
    }
  end
end
