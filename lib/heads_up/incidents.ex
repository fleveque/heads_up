defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident

  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents do
    Incident
    |> where(status: :resolved)
    |> where([i], ilike(i.name, ^"%in%"))
    |> order_by(desc: :name)
    |> Repo.all()
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end

  def statuses do
    Ecto.Enum.values(Incident, :status)
  end
end
