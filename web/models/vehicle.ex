defmodule GpsTracker.Vehicle do
  use GpsTracker.Web, :model

  schema "vehicles" do
    field :code, :string

    has_many :locations, GpsTracker.Location

    timestamps
  end

  @required_fields ~w(code)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
