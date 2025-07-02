defmodule HeadsUpWeb.CustomComponents do
  use HeadsUpWeb, :html

  attr :status, :atom, values: [:pending, :resolved, :canceled], default: :pending
  attr :class, :string, default: ""
  # For any global attributes you want to pass (id, phx-click...)
  attr :rest, :global

  def badge(assigns) do
    ~H"""
    <div
      class={[
        "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
        @status == :resolved && "text-lime-600 border-lime-600",
        @status == :pending && "text-yellow-600 border-yellow-600",
        @status == :canceled && "text-red-600 border-red-600",
        @class
      ]}
      {@rest}
    >
      {@status}
    </div>
    """
  end
end
