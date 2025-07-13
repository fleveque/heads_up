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
    |> with_category(filter["category"])
    |> sort(filter["sort_by"])
    |> preload([:category])
    |> Repo.all()
  end

  defp with_status(query, status) when status in @valid_statuses do
    where(query, status: ^status)
  end

  defp with_status(query, _status), do: query

  defp with_category(query, slug) when slug in ["", nil], do: query

  defp with_category(query, slug) do
    # That would be the usual case, but we want to use slugs instead of IDs
    # where(query, [i], i.category_id == ^category)

    # If you don't have an Ecto association set up, you can use a join like this:
    # from(i in query,
    #   join: c in Category,
    #   on: i.category_id == c.id,
    #   where: c.slug == ^slug
    # )

    # Alternative using assoc if you have Ecto associations set up
    from(i in query,
      join: c in assoc(i, :category),
      where: c.slug == ^slug
      # preload: [category: c]
    )

    # Or using macro syntax
    # query
    # |> join(:inner, [i], c in assoc(i, :category))
    # |> where([i, c], c.slug == ^slug)
  end

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end

  defp sort(query, nil), do: query

  defp sort(query, "name"), do: order_by(query, asc: :name)

  defp sort(query, "priority_desc"), do: order_by(query, desc: :priority)

  defp sort(query, "priority_asc"), do: order_by(query, asc: :priority)

  defp sort(query, "category") do
    from i in query,
      join: c in assoc(i, :category),
      order_by: [asc: c.name]

    # or using macro syntax
    # query
    # |> join(:inner, [i], c in assoc(i, :category))
    # |> order_by([i, c], asc: c.name)
  end

  defp sort(query, _), do: order_by(query, :id)

  def get_incident!(id) do
    Repo.get!(Incident, id)
    |> Repo.preload(:category)
  end

  def list_responses(incident) do
    incident
    |> Ecto.assoc(:responses)
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
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
