defmodule CodeNameWeb.RoomsLive do
  use CodeNameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"player_nickname" => player_nickname}, _url, socket) do
    socket =
      assign(socket,
        player_nickname: player_nickname
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("create-room", _, socket) do
    room_token =
      RandomStringGenerator.generate("LLLllllddddd")
      |> RandomStringGenerator.shuffle()

    socket =
      push_redirect(socket,
        to:
          Routes.live_path(
            socket,
            CodeNameWeb.WaitingRoomLive,
            player_nickname: socket.assigns.player_nickname,
            room_token: room_token
          )
      )

    {:noreply, socket}
  end
end
