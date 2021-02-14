defmodule CodeNameWeb.RoomsLive do
  use CodeNameWeb, :live_view
  alias CodeName.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"player_nickname" => player_nickname}, _url, socket) do
    socket =
      assign(socket,
        player_nickname: player_nickname,
        room_id: ""
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("create-room", _, socket) do
    {:ok, room} =
      Rooms.create_room(%{
        players: [socket.assigns.player_nickname]
      })

    socket =
      push_redirect(socket,
        to:
          Routes.live_path(
            socket,
            CodeNameWeb.WaitingRoomLive,
            player_nickname: socket.assigns.player_nickname,
            room_id: Integer.to_string(room.id)
          )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("room-choice", %{"room_id" => room_id}, socket) do
    socket =
      push_redirect(socket,
        to:
          Routes.live_path(
            socket,
            CodeNameWeb.WaitingRoomLive,
            player_nickname: socket.assigns.player_nickname,
            room_id: room_id
          )
      )

    room = Rooms.get_room!(String.to_integer(room_id))

    Rooms.update_room(room, %{players: [socket.assigns.player_nickname | room.players]})

    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:player_joined, player_nickname: socket.assigns.player_nickname}
    )

    {:noreply, socket}
  end
end
