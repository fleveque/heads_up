defmodule HeadsUp.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HeadsUp.Categories` context.
  """

  @doc """
  Generate a unique category name.
  """
  def unique_category_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique category slug.
  """
  def unique_category_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: unique_category_name(),
        slug: unique_category_slug()
      })
      |> HeadsUp.Categories.create_category()

    category
  end
end
