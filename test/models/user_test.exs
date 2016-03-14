defmodule GpsTracker.UserTest do
  use GpsTracker.ModelCase

  alias GpsTracker.User

  @valid_attrs %{password: "secret", email: "test@test.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
