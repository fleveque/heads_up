defmodule HeadsUpWeb.CategoryLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Categories

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Categories
      <:actions>
        <.button phx-click={JS.dispatch("click", to: {:inner, "a"})}>
          <.link navigate={~p"/categories/new"}>
            New Category
          </.link>
        </.button>
      </:actions>
    </.header>

    <.table
      id="categories"
      rows={@streams.categories}
      row_click={fn {_id, category} -> JS.navigate(~p"/categories/#{category}") end}
    >
      <:col :let={{_id, category}} label="Name">{category.name}</:col>
      <:col :let={{_id, category}} label="Slug">{category.slug}</:col>
      <:action :let={{_id, category}}>
        <div class="sr-only">
          <.link navigate={~p"/categories/#{category}"}>Show</.link>
        </div>
        <.link navigate={~p"/categories/#{category}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, category}}>
        <.link
          phx-click={JS.push("delete", value: %{id: category.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Categories")
     |> stream(:categories, Categories.list_categories())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Categories.get_category!(id)
    {:ok, _} = Categories.delete_category(category)

    {:noreply, stream_delete(socket, :categories, category)}
  end
end
