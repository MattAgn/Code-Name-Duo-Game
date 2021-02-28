defmodule CodeName.Repo.Migrations.AddPlayerKeymapColumn do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :player_1_keymap, {:array, :string}
      add :player_2_keymap, {:array, :string}
    end
  end
end
