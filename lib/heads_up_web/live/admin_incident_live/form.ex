defmodule HeadsUpWeb.AdminIncidentLive.Form do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(%{}, as: "incident"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-form">
      <.header>
        {@page_title}
      </.header>
      <.simple_form for={@form} id="incident-form">
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
          <.button>Save incident</.button>
        </:actions>
      </.simple_form>

      <.back navigate={~p"/admin/incidents"}>
        Cancel
      </.back>
    </div>
    """
  end
end
