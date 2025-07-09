defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Incidents
  alias HeadsUp.Admin

  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(%Incident{})

    socket
    |> assign(:page_title, "New Incident")
    |> assign(:form, to_form(changeset))
    |> assign(:incident, incident)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident)

    socket
    |> assign(:page_title, "Edit Incident")
    |> assign(:form, to_form(changeset))
    |> assign(:incident, incident)
  end

  def render(assigns) do
    ~H"""
    <div class="admin-form">
      <.header>
        {@page_title}
      </.header>
      <.simple_form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
        <.input field={@form[:name]} label="Name" phx-debounce="blur" />
        <.input field={@form[:description]} label="Description" type="textarea" phx-debounce="blur" />
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

  def handle_event("validate", %{"incident" => incident_params}, socket) do
    changeset = Admin.change_incident(socket.assigns.incident, incident_params)

    socket =
      socket
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("save", %{"incident" => incident_params}, socket) do
    socket = save_incident(socket, socket.assigns.live_action, incident_params)

    {:noreply, socket}
  end

  defp save_incident(socket, :new, incident_params) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
        socket
        |> put_flash(:info, "Incident created successfully.")
        |> push_navigate(to: ~p"/admin/incidents")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:error, "Failed to create incident.")
        |> assign(:form, to_form(changeset))
    end
  end

  defp save_incident(socket, :edit, incident_params) do
    case Admin.update_incident(socket.assigns.incident, incident_params) do
      {:ok, _incident} ->
        socket
        |> put_flash(:info, "Incident updated successfully.")
        |> push_navigate(to: ~p"/admin/incidents")

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:error, "Failed to update incident.")
        |> assign(:form, to_form(changeset))
    end
  end
end
