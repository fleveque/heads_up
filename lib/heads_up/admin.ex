defmodule HeadsUp.Admin do
  alias HeadsUp.Incidents.Incident

  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_incident(attrs \\ %{}) do
    %Incident{}
    |> Incident.changeset(attrs)
    |> Repo.insert()
  end

  def update_incident(%Incident{} = incident, attrs) do
    incident
    |> Incident.changeset(attrs)
    |> Repo.update()
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    Incident.changeset(incident, attrs)
  end
end
