defmodule CodeName.Game do
  alias CodeName.Words

  def generate_board do
    words =
      Words.list_words()
      |> Enum.map(fn x -> x.word end)
      |> Enum.take_random(25)

    indexes = Enum.to_list(0..24) |> Enum.shuffle()

    common_cards = Enum.take(indexes, 4)
    [common_assassin | common_code_names] = common_cards

    non_common_cards = Enum.take(indexes, -21)

    [p1_assassin_1, p1_assassin_2, p2_assassin_1, p2_assassin_2 | neutral_or_code_names] =
      non_common_cards

    player_1_assasins_cards = [common_assassin, p1_assassin_1, p1_assassin_2]
    player_2_assasins_cards = [common_assassin, p2_assassin_1, p2_assassin_2]

    player_1_unique_code_names =
      ([p2_assassin_1, p2_assassin_2] ++ neutral_or_code_names)
      |> Enum.shuffle()
      |> Enum.take(6)

    player_2_unique_code_names =
      ([p1_assassin_1, p1_assassin_2] ++ neutral_or_code_names)
      |> Enum.filter(fn el -> !Enum.member?(player_1_unique_code_names, el) end)
      |> Enum.shuffle()
      |> Enum.take(6)

    player_1_code_name_cards = common_code_names ++ player_1_unique_code_names
    player_2_code_name_cards = common_code_names ++ player_2_unique_code_names

    player_1_keymap =
      Enum.to_list(0..24)
      |> Enum.map(fn x ->
        cond do
          Enum.member?(player_1_assasins_cards, x) -> "assassin"
          Enum.member?(player_1_code_name_cards, x) -> "code_name"
          true -> "neutral"
        end
      end)

    player_2_keymap =
      Enum.to_list(0..24)
      |> Enum.map(fn x ->
        cond do
          Enum.member?(player_2_assasins_cards, x) -> "assassin"
          Enum.member?(player_2_code_name_cards, x) -> "code_name"
          true -> "neutral"
        end
      end)

    %{
      player_1_keymap: player_1_keymap,
      player_2_keymap: player_2_keymap,
      words: words,
      current_results: Enum.to_list(0..24) |> Enum.map(fn _ -> "hidden" end)
    }
  end

  def is_game_lost_on_round_finished_click(round) do
    round >= 9
  end

  def is_game_lost_on_card_click(card_result, round) do
    card_result === "assassin" || (String.starts_with?(card_result, "neutral") && round == 9)
  end

  def is_game_won(current_results) do
    Enum.count(Enum.filter(current_results, fn x -> x === "code_name" end)) == 15
  end

  def is_code_name_discovered(card_result) do
    card_result === "code_name"
  end

  ########## EVENTS ###############
  def send_game_won_event(room_id, updated_results) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:game_won, updated_results: updated_results}
    )
  end

  def send_game_lost_event(room_id, updated_results) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:game_lost, updated_results: updated_results}
    )
  end

  def send_round_finished_event(room_id, updated_results) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:round_finished, updated_results: updated_results}
    )
  end

  def send_code_name_discovered_event(room_id, updated_results) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:code_name_discovered, updated_results: updated_results}
    )
  end
end
