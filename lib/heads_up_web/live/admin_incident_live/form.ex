defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Incidents
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    changeset = Incident.changeset(%Incident{}, %{})

    socket =
      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-form">
      <.header>
        {@page_title}
      </.header>
      <.simple_form for={@form} id="incident-form" phx-submit="save">
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:description]} label="Description" type="textarea" />
        <.input field={@form[:priority]} type="number" label="Priority" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a status"
          options={Incidents.statuses()}
        />
        <.input field={@form[:image_path]} label="Image path" />
        <:actions>
          <.button phx-disable-with="Saving...">Save incident</.button>
        </:actions>
      </.simple_form>

      <.back navigate={~p"/admin/incidents"}>
        Cancel
      </.back>
    </div>
    """
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created successfully.")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> put_flash(:error, "Failed to create incident.")
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end
end
