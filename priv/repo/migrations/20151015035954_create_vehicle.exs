defmodule GpsTracker.Repo.Migrations.CreateVehicle do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :code, :string

      timestamps
    end

  end
end
