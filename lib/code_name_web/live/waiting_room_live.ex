defmodule CodeNameWeb.WaitingRoomLive do
  use CodeNameWeb, :live_view
  alias CodeName.Rooms
  alias CodeName.Game

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
            do: [all_players | new_player_nickname]
        end
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {:game_started,
         player_1_key_map: player_1_key_map,
         player_2_key_map: player_2_key_map,
         words: words,
         player_1: player_1,
         player_2: player_2},
        socket
      ) do
    socket =
      assign(socket,
        player_1_key_map: player_1_key_map,
        player_2_key_map: player_2_key_map,
        words: words,
        player_1: player_1,
        player_2: player_2
      )

    socket =
      push_redirect(socket,
        to:
          Routes.live_path(
            socket,
            CodeNameWeb.BoardLive,
            player_nickname: socket.assigns.player_nickname,
            room_id: socket.assigns.room_id,
            player_1_key_map: player_1_key_map,
            player_2_key_map: player_2_key_map,
            words: words,
            player_1: player_1,
            player_2: player_2,
            player_turn: player_1
          )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("start-game", _, socket) do
    %{player_1_key_map: player_1_key_map, player_2_key_map: player_2_key_map, words: words} =
      Game.generate_board()

    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      socket.assigns.room_id,
      {:game_started,
       player_1_key_map: player_1_key_map,
       player_2_key_map: player_2_key_map,
       words: words,
       player_1: Enum.at(socket.assigns.all_players, 0),
       player_2: Enum.at(socket.assigns.all_players, 1)}
    )

    {:noreply, socket}
  end
end
