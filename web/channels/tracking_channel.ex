defmodule GpsTracker.TrackingChannel do
  use GpsTracker.Web, :channel
  alias RethinkDB.Query

  def join("tracking:home", _payload, socket) do
    send self, :after_join
    {:ok, socket} 
  end

  def handle_info(:after_join, socket) do
    spawn __MODULE__, :send_location, [socket]
    {:noreply, socket}
  end

  def send_location(socket) do
    Query.table("locations")
    |> Query.changes
    |> RethinkRepo.run
    |> Stream.take_every(1)
    |> Enum.each fn(change) ->
      %{"new_val" => location} = change
      push socket, "new_location", location 
    end 
  end
end
