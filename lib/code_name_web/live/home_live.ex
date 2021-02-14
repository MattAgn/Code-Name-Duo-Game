defmodule CodeNameWeb.HomeLive do
  use CodeNameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, player_nickname: "")
    {:ok, socket}
  end

  @impl true
  def handle_event("player-nickname-choice", %{"player_nickname" => player_nickname}, socket) do
    # TODO: handle unicity / id of player nicknames
    IO.puts(player_nickname)

    socket =
      push_redirect(socket,
        to:
          Routes.live_path(
            socket,
            CodeNameWeb.RoomsLive,
            player_nickname: player_nickname
          )
      )

    {:noreply, socket}
  end
end
