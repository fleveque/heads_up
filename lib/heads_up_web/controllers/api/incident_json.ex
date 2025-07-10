defmodule HeadsUpWeb.Api.IncidentJSON do
  def index(%{incidents: incidents}) do
    %{incidents: for(incident <- incidents, do: data(incident))}
  end

  def show(%{incident: incident}) do
    %{incident: data(incident)}
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
