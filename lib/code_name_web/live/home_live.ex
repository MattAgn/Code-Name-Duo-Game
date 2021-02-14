defmodule CodeNameWeb.HomeLive do
  use CodeNameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, player_nickname: "")
    {:ok, socket}
  end
end
