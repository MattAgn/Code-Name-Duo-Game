defmodule CodeNameWeb.WaitingRoomLive do
  use CodeNameWeb, :live_view
  alias CodeName.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"player_nickname" => player_nickname, "room_id" => room_id},
        _url,
        socket
      ) do
    players = Rooms.get_room!(String.to_integer(room_id)).players

    socket =
      assign(socket,
        player_nickname: player_nickname,
        all_players: players,
        room_id: room_id
      )

    if connected?(socket), do: Rooms.subscribe(room_id)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:player_joined, player_nickname: new_player_nickname}, socket) do
    socket =
      update(
        socket,
        :all_players,
        fn all_players ->
          if new_player_nickname != socket.assigns.player_nickname,
            do: [new_player_nickname | all_players]
        end
      )

    {:noreply, socket}
  end
end
