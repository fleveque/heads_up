defmodule HeadsUp.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :note, :text
      add :status, :string
      add :incident_id, references(:incidents, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:responses, [:incident_id])
    create index(:responses, [:user_id])
  end
end
