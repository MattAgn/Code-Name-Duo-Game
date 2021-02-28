defmodule CodeName.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :players, {:array, :string}
    field :words, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:players, :words])
  end
end
