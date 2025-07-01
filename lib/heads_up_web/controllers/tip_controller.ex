defmodule HeadsUpWeb.TipController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Tips

  def index(conn, _params) do
    emojis = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(5)
    tips = Tips.list_tips()

    render(conn, :index, emojis: emojis, tips: tips)
  end

  def show(conn, %{"id" => id}) do
    case Tips.get_tip(id) do
      nil ->
        conn
        |> put_flash(:error, "Tip not found")
        |> redirect(to: "/tips")

      tip ->
        render(conn, :show, tip: tip)
    end
  end
end
