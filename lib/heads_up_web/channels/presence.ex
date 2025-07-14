defmodule HeadsUpWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :heads_up,
    pubsub_server: HeadsUp.PubSub

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    for {username, %{metas: _presence}} <- joins do
      presence = %{id: username, metas: Map.fetch!(presences, username)}
      msg = {:user_joined, presence}

      Phoenix.PubSub.local_broadcast(
        HeadsUp.PubSub,
        "updates:" <> topic,
        msg
      )
    end

    for {username, %{metas: _presence}} <- leaves do
      metas =
        case Map.fetch!(presences, username) do
          {:ok, presence_metas} -> presence_metas
          :error -> []
        end

      presence = %{id: username, metas: metas}
      msg = {:user_left, presence}

      Phoenix.PubSub.local_broadcast(
        HeadsUp.PubSub,
        "updates:" <> topic,
        msg
      )
    end

    {:ok, state}
  end

  def topic(id), do: "incident_watchers:#{id}"

  def track_user(id, current_user) do
    {:ok, _} =
      track(self(), topic(id), current_user.username, %{
        online_at: System.system_time(:second),
        is_admin: current_user.is_admin
      })
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(HeadsUp.PubSub, "updates:" <> topic(id))
  end

  def list_users(id) do
    list(topic(id))
    |> Enum.map(fn {username, %{metas: metas}} ->
      %{
        id: username,
        metas: metas
      }
    end)
  end
end
