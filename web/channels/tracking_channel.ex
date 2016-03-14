defmodule GpsTracker.TrackingChannel do
  use GpsTracker.Web, :channel
  alias GpsTracker.{Vehicle, Location}

  def join("tracking:home", _payload, socket) do
    send self, :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    vehicles = Repo.all(Vehicle)
    Enum.each(vehicles, fn vehicle ->
      locations = Repo.all from l in Location, where: l.vehicle_id == ^vehicle.id, order_by: [desc: l.inserted_at], limit: 1
      last_location = List.first(locations)
      if last_location != nil do
          data = GpsTracker.LocationView.render("location.json", %{location: last_location})
          push socket, "new_location", data
      end
    end)
    {:noreply, socket}
  end
end
