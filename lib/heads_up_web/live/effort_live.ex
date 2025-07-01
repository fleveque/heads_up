defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, responders: 0, minutes_per_responder: 10)}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <section>
        <button phx-click="add" phx-value-quantity="1">
          <span class="icon">➕</span>
          <span>Increase Responders</span>
        </button>
        <div>
          {@responders}
        </div>
        &times;
        <div>
          {@minutes_per_responder}
        </div>
        =
        <div>
          {@responders * @minutes_per_responder}
        </div>
      </section>

      <form phx-submit="set-minutes">
        <label>Minutes Per Responder:</label>
        <input type="number" name="minutes" value="1" min="1" />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    quantity = String.to_integer(quantity)

    {:noreply, update(socket, :responders, &(&1 + quantity))}
  end

  def handle_event("set-minutes", %{"minutes" => minutes}, socket) do
    minutes = String.to_integer(minutes)

    {:noreply, assign(socket, :minutes_per_responder, minutes)}
  end
end
