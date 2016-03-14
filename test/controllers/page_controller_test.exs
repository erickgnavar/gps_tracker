defmodule GpsTracker.PageControllerTest do
  use GpsTracker.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "GPS Tracking"
  end
end
