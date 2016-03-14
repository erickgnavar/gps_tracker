defmodule GpsTracker.TrackingChannel do
  use GpsTracker.Web, :channel

  def join("tracking:home", _payload, socket) do
    {:ok, socket}
  end
end
