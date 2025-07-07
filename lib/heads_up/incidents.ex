defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident

  alias HeadsUp.Repo
  import Ecto.Query

  @valid_statuses Ecto.Enum.values(Incident, :status) |> Enum.map(&to_string/1)

  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in @valid_statuses do
    where(query, status: ^status)
  end

  defp with_status(query, _status), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end

  defp sort(query, nil), do: query

  defp sort(query, "name"), do: order_by(query, asc: :name)
  defp sort(query, "priority_desc"), do: order_by(query, desc: :priority)
  defp sort(query, "priority_asc"), do: order_by(query, asc: :priority)
  defp sort(query, _), do: order_by(query, :id)

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    # Simulate a delay for fetching urgent incidents
    Process.sleep(2000)

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
