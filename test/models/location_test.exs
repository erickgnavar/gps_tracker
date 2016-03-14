defmodule GpsTracker.LocationTest do
  use GpsTracker.ModelCase

  alias GpsTracker.{Vehicle, Location}

  @valid_attrs %{latitude: "120.5", longitude: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    {:ok, vehicle} = Repo.insert(Vehicle.changeset(%Vehicle{}, %{"code" => "test"}))
    changeset = Location.changeset(%Location{}, Map.put(@valid_attrs, :vehicle_id, vehicle.id))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end
end
