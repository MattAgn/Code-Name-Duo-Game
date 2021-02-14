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

    [
      player_1_assasins_cards: player_1_assasins_cards,
      player_1_code_name_cards: player_1_code_name_cards,
      player_2_assasins_cards: player_2_assasins_cards,
      player_2_code_name_cards: player_2_code_name_cards,
      words: words
    ]
  end
end
