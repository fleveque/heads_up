defmodule HeadsUpWeb.Hooks do
  use HeadsUpWeb, :live_view

  @doc """
  An example hook to assign the current time to the socket.
  This can be used to display the current time in the UI or for any other purpose.
  """

  def on_mount(:current_time, _params, _session, socket) do
    {:cont, assign(socket, :current_time, DateTime.utc_now())}
  end
end
