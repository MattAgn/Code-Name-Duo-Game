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
        current_results: Enum.to_list(0..24) |> Enum.map(fn _ -> "hidden" end),
        words: words,
        round: 0,
        game_status: "ongoing"
      )

    if connected?(socket), do: Rooms.subscribe(room_id)

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {:card_click, player: player_nickname, card_index: card_index},
        socket
      ) do
    prev_result = Enum.at(socket.assigns.current_results, String.to_integer(card_index))

    result =
      get_key_map_for_player(socket, player_nickname)
      |> Enum.at(String.to_integer(card_index))
      |> handle_neutral_result(prev_result, player_nickname)

    current_results =
      Enum.to_list(socket.assigns.current_results)
      |> List.replace_at(String.to_integer(card_index), result)

    if result === "assassin" do
      Phoenix.PubSub.broadcast(
        CodeName.PubSub,
        socket.assigns.room_id,
        {:game_lost}
      )
    end

    if String.starts_with?(result, "neutral") do
      {:noreply,
       assign(socket, current_results: current_results, round: socket.assigns.round + 1)}
    else
      {:noreply, assign(socket, current_results: current_results)}
    end
  end

  @impl true
  def handle_info(
        {:round_finish_button_click, player: player_nickname},
        socket
      ) do
    socket = assign(socket, round: socket.assigns.round + 1)

    if socket.assigns.round == 10 do
      Phoenix.PubSub.broadcast(
        CodeName.PubSub,
        socket.assigns.room_id,
        {:game_lost}
      )
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:game_lost}, socket) do
    socket = assign(socket, game_status: "lost")

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

  @impl true
  def handle_event("finish-round", _, socket) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      socket.assigns.room_id,
      {:round_finish_button_click, player: socket.assigns.player_nickname}
    )

    {:noreply, socket}
  end

  defp handle_neutral_result(result, previous_result, player_nickname) do
    cond do
      result === "neutral" && String.starts_with?(previous_result, "neutral-") -> "neutral-all"
      result === "neutral" -> "neutral-" <> player_nickname
      true -> result
    end
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

  defp get_card_color_class(current_results, card_index) do
    cond do
      Enum.at(current_results, card_index) === "assassin" -> "black"
      Enum.at(current_results, card_index) === "code_name" -> "green"
      true -> "beige"
    end
  end

  defp get_key_map_square_color_class(socket_assigns, card_index) do
    cond do
      Enum.at(get_my_key_map(socket_assigns), card_index) === "assassin" -> "black"
      Enum.at(get_my_key_map(socket_assigns), card_index) === "code_name" -> "green"
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
end
