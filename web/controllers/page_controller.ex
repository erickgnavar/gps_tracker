defmodule GpsTracker.PageController do
  use GpsTracker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
