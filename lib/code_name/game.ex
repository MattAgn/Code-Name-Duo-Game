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

    player_1_key_map =
      Enum.to_list(0..24)
      |> Enum.map(fn x ->
        cond do
          Enum.member?(player_1_assasins_cards, x) -> :assassin
          Enum.member?(player_1_code_name_cards, x) -> :code_name
          true -> :neutral
        end
      end)

    player_2_key_map =
      Enum.to_list(0..24)
      |> Enum.map(fn x ->
        cond do
          Enum.member?(player_2_assasins_cards, x) -> :assassin
          Enum.member?(player_2_code_name_cards, x) -> :code_name
          true -> :neutral
        end
      end)

    %{
      player_1_key_map: player_1_key_map,
      player_2_key_map: player_2_key_map,
      words: words
    }
  end

  def send_game_won_event(room_id) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:game_won}
    )
  end

  def send_game_lost_event(room_id) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:game_lost}
    )
  end

  def send_round_finished_click_event(room_id, player_nickname) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:round_finish_button_click, player_nickname: player_nickname}
    )
  end

  def send_card_click_event(room_id, player_nickname, card_index) do
    Phoenix.PubSub.broadcast(
      CodeName.PubSub,
      room_id,
      {:card_click, player: player_nickname, card_index: card_index}
    )
  end
end
