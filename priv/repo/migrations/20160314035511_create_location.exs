defmodule GpsTracker.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :latitude, :float
      add :longitude, :float
      add :vehicle_id, references(:vehicles, on_delete: :delete_all), null: false

      timestamps
    end
    create index(:locations, [:vehicle_id])

  end
end
