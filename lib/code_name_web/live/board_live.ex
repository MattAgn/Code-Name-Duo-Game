defmodule CodeNameWeb.BoardLive do
  use CodeNameWeb, :live_view
  alias CodeName.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{
          "player_nickname" => player_nickname,
          "room_id" => room_id,
          "board" => board,
          "player_1" => player_1,
          "player_2" => player_2
        },
        _url,
        socket
      ) do
    %{
      "player_1_key_map" => player_1_key_map,
      "player_2_key_map" => player_2_key_map,
      "words" => words
    } = board

    socket =
      assign(socket,
        player_nickname: player_nickname,
        room_id: room_id,
        player_2: player_2,
        player_1: player_1,
        player_1_key_map: player_1_key_map,
        player_2_key_map: player_2_key_map,
        current_results: Enum.to_list(0..24) |> Enum.map(fn _ -> :hidden end),
        words: words
      )

    if connected?(socket), do: Rooms.subscribe(room_id)

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {:card_click, player: player_nickname, card_index: card_index},
        socket
      ) do
    result =
      get_key_map_for_player(socket, player_nickname) |> Enum.at(String.to_integer(card_index))

    current_results =
      Enum.to_list(socket.assigns.current_results)
      |> List.replace_at(String.to_integer(card_index), result)

    socket = assign(socket, current_results: current_results)

    {:noreply, socket}
  end

  @impl true
  def handle_event("card-click", %{"card-index" => card_index}, socket) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      socket.assigns.room_id,
      {:card_click, player: socket.assigns.player_nickname, card_index: card_index}
    )

    {:noreply, socket}
  end

  defp get_key_map_for_player(socket, player_nickname) do
    if player_nickname === socket.assigns.player_nickname do
      get_my_partner_key_map(socket.assigns)
    else
      get_my_key_map(socket.assigns)
    end
  end

  defp get_my_key_map(socket_assigns) do
    if socket_assigns.player_nickname === socket_assigns.player_1 do
      socket_assigns.player_1_key_map
    else
      socket_assigns.player_2_key_map
    end
  end

  defp get_my_partner_key_map(socket_assigns) do
    if socket_assigns.player_nickname === socket_assigns.player_1 do
      socket_assigns.player_2_key_map
    else
      socket_assigns.player_1_key_map
    end
  end
end
