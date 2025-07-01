defmodule HeadsUpWeb.TipHTML do
  @moduledoc """
  This module contains pages rendered by TipController.

  See the `tip_html` directory for all templates available.
  """
  use HeadsUpWeb, :html

  embed_templates "tip_html/*"
end
