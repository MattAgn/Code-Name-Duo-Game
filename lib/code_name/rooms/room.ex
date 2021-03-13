defmodule CodeName.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :players, {:array, :string}
    field :words, {:array, :string}
    field :player_1_keymap, {:array, :string}
    field :player_2_keymap, {:array, :string}
    field :current_results, {:array, :string}
    field :current_round, :integer
    # nickname of the player who has to play
    # TODO: use 1 or 2 instead, via enum
    field :player_turn, :string
    field :game_status, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [
      :players,
      :words,
      :player_2_keymap,
      :player_1_keymap,
      :current_results,
      :current_round,
      :player_turn,
      :game_status
    ])
  end
end
