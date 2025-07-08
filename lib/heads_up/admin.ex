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
    %Incident{
      name: attrs["name"],
      description: attrs["description"],
      priority: attrs["priority"] |> String.to_integer(),
      status: attrs["status"] |> String.to_existing_atom(),
      image_path: attrs["image_path"]
    }
    |> Repo.insert!()
  end
end
