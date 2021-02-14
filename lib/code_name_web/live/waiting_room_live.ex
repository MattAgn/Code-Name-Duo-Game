defmodule CodeNameWeb.WaitingRoomLive do
  use CodeNameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"player_nickname" => player_nickname, "room_token" => room_token},
        _url,
        socket
      ) do
    socket =
      assign(socket,
        player_nickname: player_nickname,
        room_token: room_token
      )

    {:noreply, socket}
  end
end
