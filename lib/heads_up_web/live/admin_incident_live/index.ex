defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Admin
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: "fade-in",
          out: "fade-out"
        )
      }>
        Toggle Joke
      </.button>

      <div id="joke" class="joke hidden" phx-click={JS.toggle_class("blur")}>
        Why shouldn't you trust trees, {@current_user.username}?
      </div>
      <.header class="mt-6">
        {@page_title}
        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">
            New Incident
          </.link>
        </:actions>
      </.header>
      <.table
        id="incidents"
        rows={@streams.incidents}
        row_click={fn {_dom_id, incident} -> JS.navigate(~p"/incidents/#{incident}") end}
      >
        <:col :let={{_dom_id, incident}} label="name">
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.name}
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="status">
          <.badge status={incident.status} />
        </:col>
        <:col :let={{_dom_id, incident}} label="priority">
          {incident.priority}
        </:col>
        <:action :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident}/edit"}>
            <.icon name="hero-pencil" class="h-4 w-4" /> Edit
          </.link>
        </:action>
        <:action :let={{dom_id, incident}}>
          <.link phx-click={delete_and_hide(dom_id, incident)} data-confirm="Are you sure?">
            <.icon name="hero-trash" class="h-4 w-4" /> Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)
    {:ok, _} = Admin.delete_incident(incident)

    {:noreply, stream_delete(socket, :incidents, incident)}
  end

  def delete_and_hide(dom_id, incident) do
    JS.push("delete", value: %{id: incident.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
