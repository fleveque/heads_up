defmodule HeadsUpWeb.Api.IncidentJSON do
  def index(%{incidents: incidents}) do
    %{incidents: for(incident <- incidents, do: data(incident))}
  end

  def show(%{incident: incident}) do
    %{incident: data(incident)}
  end

  def error(%{changeset: changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)

    %{errors: errors}
  end

  defp data(incident) do
    %{
      id: incident.id,
      name: incident.name,
      description: incident.description,
      status: incident.status,
      priority: incident.priority,
      category_id: incident.category_id
    }
  end
end
