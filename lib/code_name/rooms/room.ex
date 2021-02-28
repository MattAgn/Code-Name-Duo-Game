defmodule CodeName.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :players, {:array, :string}
    field :words, {:array, :string}
    field :player_1_keymap, {:array, :string}
    field :player_2_keymap, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:players, :words, :player_2_keymap, :player_1_keymap])
  end
end
