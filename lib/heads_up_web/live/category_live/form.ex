defmodule HeadsUpWeb.CategoryLive.Form do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Categories
  alias HeadsUp.Categories.Category

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
      <:subtitle>Use this form to manage category records in your database.</:subtitle>
    </.header>

    <.simple_form for={@form} id="category-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:slug]} type="text" label="Slug" />
      <:actions>
        <.button phx-disable-with="Saving...">Save Category</.button>
      </:actions>
    </.simple_form>

    <.back navigate={return_path(@return_to, @category)}>Back</.back>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    category = Categories.get_category!(id)

    socket
    |> assign(:page_title, "Edit Category")
    |> assign(:category, category)
    |> assign(:form, to_form(Categories.change_category(category)))
  end

  defp apply_action(socket, :new, _params) do
    category = %Category{}

    socket
    |> assign(:page_title, "New Category")
    |> assign(:category, category)
    |> assign(:form, to_form(Categories.change_category(category)))
  end

  @impl true
  def handle_event("validate", %{"category" => category_params}, socket) do
    changeset = Categories.change_category(socket.assigns.category, category_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    save_category(socket, socket.assigns.live_action, category_params)
  end

  defp save_category(socket, :edit, category_params) do
    case Categories.update_category(socket.assigns.category, category_params) do
      {:ok, category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, category))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_category(socket, :new, category_params) do
    case Categories.create_category(category_params) do
      {:ok, category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, category))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _category), do: ~p"/categories"
  defp return_path("show", category), do: ~p"/categories/#{category}"
end
