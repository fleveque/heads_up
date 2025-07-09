defmodule HeadsUpWeb.CategoryLive.Show do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Categories

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Category {@category.id}
      <:subtitle>This is a category record from your database.</:subtitle>
      <:actions>
        <.button phx-click={JS.dispatch("click", to: {:inner, "a"})}>
          <.link navigate={~p"/categories/#{@category}/edit?return_to=show"}>
            Edit category
          </.link>
        </.button>
      </:actions>
    </.header>

    <.list>
      <:item title="Name">{@category.name}</:item>
      <:item title="Slug">{@category.slug}</:item>
    </.list>

    <.back navigate={~p"/categories"}>Back to categories</.back>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Category")
     |> assign(:category, Categories.get_category!(id))}
  end
end
