defmodule HeadsUp.ResponsesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HeadsUp.Responses` context.
  """

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    {:ok, response} =
      attrs
      |> Enum.into(%{
        note: "some note",
        status: :enroute
      })
      |> HeadsUp.Responses.create_response()

    response
  end
end
