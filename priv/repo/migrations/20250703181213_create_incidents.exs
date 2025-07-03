defmodule HeadsUp.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents) do
      add :name, :string
      add :description, :text
      add :priority, :integer
      add :status, :string
      add :image_path, :string

      timestamps(type: :utc_datetime)
    end
  end
end
