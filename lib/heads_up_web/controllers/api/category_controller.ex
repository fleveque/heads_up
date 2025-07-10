defmodule HeadsUpWeb.Api.CategoryController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Categories

  def show(conn, %{"id" => id}) do
    category = Categories.get_category_with_incidents!(id)

    render(conn, :show, category: category)
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: HeadsUpWeb.ErrorJSON)
      |> render(:"404")
  end
end
