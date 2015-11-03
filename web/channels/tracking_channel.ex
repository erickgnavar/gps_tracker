defmodule GpsTracker.TrackingChannel do
  use GpsTracker.Web, :channel
  alias RethinkDB.Query

  def join("tracking:home", _payload, socket) do
    send self, :after_join
    {:ok, socket} 
  end

  def terminate(reason, socket) do
    pid = socket.assigns[:stream_pid]
    Process.exit pid, :kill   
  end

  def handle_info(:after_join, socket) do
    pid = spawn __MODULE__, :stream_locations, [socket]
    spawn __MODULE__, :push_last_location_by_vehicle, [socket]
    socket = assign(socket, :stream_pid, pid)
    {:noreply, socket}
  end

  def push_last_location_by_vehicle(socket) do
    Query.table("locations")
    |> RethinkRepo.run
    |> Enum.group_by(%{}, fn (a) -> a["vehicle_id"] end)
    |> Enum.map(fn(x) ->
      {_, locations} = x
      [res|_] = locations
      |> Enum.sort(&(&1 > &2))
      res
    end)
    |> Enum.each fn(location) ->
      push socket, "new_location", location
    end
  end

  def stream_locations(socket) do
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
