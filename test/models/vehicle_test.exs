defmodule GpsTracker.VehicleTest do
  use GpsTracker.ModelCase

  alias GpsTracker.Vehicle

  @valid_attrs %{code: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vehicle.changeset(%Vehicle{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vehicle.changeset(%Vehicle{}, @invalid_attrs)
    refute changeset.valid?
  end
end
