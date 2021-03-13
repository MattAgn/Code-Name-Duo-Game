defmodule CodeNameWeb.BoardLive do
  use CodeNameWeb, :live_view
  alias CodeName.Rooms
  alias CodeName.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{
          "player_nickname" => player_nickname,
          "room_id" => room_id,
          "player_1" => player_1,
          "player_2" => player_2
        },
        _url,
        socket
      ) do
    %{
      words: words,
      player_1_keymap: player_1_keymap,
      player_2_keymap: player_2_keymap,
      current_results: current_results,
      current_round: current_round,
      player_turn: player_turn,
      game_status: game_status
    } = Rooms.get_room!(room_id)

    socket =
      assign(socket,
        player_nickname: player_nickname,
        room_id: room_id,
        player_2: player_2,
        player_1: player_1,
        player_1_keymap: player_1_keymap,
        player_2_keymap: player_2_keymap,
        current_results: current_results,
        words: words,
        current_round: current_round,
        game_status: game_status,
        player_turn: player_turn
      )

    if connected?(socket), do: Rooms.subscribe(room_id)

    {:noreply, socket}
  end

  ########### HANDLE_INFO ###############
  @impl true
  def handle_info({:round_finished, updated_results: updated_results}, socket) do
    player_turn =
      if socket.assigns.player_turn === socket.assigns.player_1,
        do: socket.assigns.player_2,
        else: socket.assigns.player_1

    socket =
      assign(socket,
        current_round: socket.assigns.current_round + 1,
        current_results: updated_results,
        player_turn: player_turn
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:game_lost, updated_results: updated_results}, socket) do
    socket = assign(socket, game_status: "lost", current_results: updated_results)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:code_name_discovered, updated_results: updated_results}, socket) do
    socket = assign(socket, current_results: updated_results)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:game_won, updated_results: updated_results}, socket) do
    socket = assign(socket, game_status: "won", current_results: updated_results)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:game_restarted}, socket) do
    %{
      words: words,
      player_1_keymap: player_1_keymap,
      player_2_keymap: player_2_keymap,
      current_results: current_results,
      current_round: current_round,
      player_turn: player_turn,
      game_status: game_status
    } = Rooms.get_room!(socket.assigns.room_id)

    socket =
      assign(socket,
        player_1_keymap: player_1_keymap,
        player_2_keymap: player_2_keymap,
        current_results: current_results,
        words: words,
        current_round: current_round,
        game_status: game_status,
        player_turn: player_turn
      )

    IO.inspect(game_status)

    {:noreply, socket}
  end

  ########### HANDLE_EVENT ###############
  @impl true
  def handle_event("card-click", %{"card-index" => card_index}, socket) do
    prev_result = Enum.at(socket.assigns.current_results, String.to_integer(card_index))

    result =
      get_keymap_for_player(socket, socket.assigns.player_nickname)
      |> Enum.at(String.to_integer(card_index))
      |> handle_neutral_result(prev_result, socket.assigns.player_nickname)

    updated_results =
      Enum.to_list(socket.assigns.current_results)
      |> List.replace_at(String.to_integer(card_index), result)

    cond do
      Game.is_game_lost_on_card_click(result, socket.assigns.current_round) ->
        Game.send_game_lost_event(socket.assigns.room_id, updated_results)
        Rooms.update_room_by_id(socket.assigns.room_id, %{game_status: "lost"})

      Game.is_game_won(updated_results) ->
        Game.send_game_won_event(socket.assigns.room_id, updated_results)
        Rooms.update_room_by_id(socket.assigns.room_id, %{game_status: "won"})

      Game.is_code_name_discovered(result) ->
        Game.send_code_name_discovered_event(socket.assigns.room_id, updated_results)

      true ->
        Game.send_round_finished_event(socket.assigns.room_id, updated_results)

        Rooms.update_room_by_id(socket.assigns.room_id, %{
          current_round: socket.assigns.current_round + 1,
          player_turn: get_player_turn(socket)
        })
    end

    Rooms.update_room_by_id(socket.assigns.room_id, %{current_results: updated_results})

    {:noreply, socket}
  end

  @impl true
  def handle_event("finish-round", _, socket) do
    Rooms.update_room_by_id(socket.assigns.room_id, %{
      current_round: socket.assigns.current_round + 1,
      player_turn: get_player_turn(socket)
    })

    if Game.is_game_lost_on_round_finished_click(socket.assigns.current_round) do
      Rooms.update_room_by_id(socket.assigns.room_id, %{game_status: "lost"})
      Game.send_game_lost_event(socket.assigns.room_id, socket.assigns.current_results)
    else
      Game.send_round_finished_event(socket.assigns.room_id, socket.assigns.current_results)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("restart-game", _, socket) do
    board_data = Game.generate_board()

    Rooms.update_room_by_id(socket.assigns.room_id, board_data)

    Game.send_game_restarted_event(socket.assigns.room_id)

    {:noreply, socket}
  end

  ############## HELPERS #################
  defp handle_neutral_result(result, previous_result, player_nickname) do
    cond do
      result === "neutral" && String.starts_with?(previous_result, "neutral-") -> "neutral-all"
      result === "neutral" -> "neutral-" <> player_nickname
      true -> result
    end
  end

  defp get_keymap_for_player(socket, player_nickname) do
    if player_nickname === socket.assigns.player_nickname do
      get_my_partner_keymap(socket.assigns)
    else
      get_my_keymap(socket.assigns)
    end
  end

  defp get_my_keymap(socket_assigns) do
    if socket_assigns.player_nickname === socket_assigns.player_1 do
      socket_assigns.player_1_keymap
    else
      socket_assigns.player_2_keymap
    end
  end

  defp get_my_partner_keymap(socket_assigns) do
    if socket_assigns.player_nickname === socket_assigns.player_1 do
      socket_assigns.player_2_keymap
    else
      socket_assigns.player_1_keymap
    end
  end

  defp get_card_color_class(current_results, card_index) do
    cond do
      Enum.at(current_results, card_index) === "assassin" -> "black"
      Enum.at(current_results, card_index) === "code_name" -> "green"
      true -> "beige"
    end
  end

  defp get_keymap_square_color_class(socket_assigns, card_index) do
    cond do
      Enum.at(get_my_keymap(socket_assigns), card_index) === "assassin" -> "black"
      Enum.at(get_my_keymap(socket_assigns), card_index) === "code_name" -> "green"
      true -> "grey"
    end
  end

  defp get_neutral_card_indicator(current_result, player_nickname) do
    cond do
      current_result === "neutral-" <> player_nickname -> "&nbsp;   &#5121;"
      current_result === "neutral-all" -> "&nbsp;   &#5121; &#5123;"
      # neutral for other player
      String.starts_with?(current_result, "neutral-") -> "&nbsp;  &#5123;"
      true -> ""
    end
  end

  defp get_round_indication(socket_assigns) do
    if is_my_turn(socket_assigns) do
      "&#128270; &nbsp; Trouver et sélectionner les mots correspondants à l'indice donné par le coéquipier"
    else
      "&#128172; &nbsp; Donner un indicer à votre coéquipier avec le nombre de mots à trouver"
    end
  end

  defp is_my_turn(socket_assigns) do
    socket_assigns.player_nickname === socket_assigns.player_turn
  end

  defp get_player_turn(socket) do
    if socket.assigns.player_1 === socket.assigns.player_turn do
      socket.assigns.player_2
    else
      socket.assigns.player_1
    end
  end
end
