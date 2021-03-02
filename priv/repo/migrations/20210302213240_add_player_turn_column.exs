defmodule CodeName.Repo.Migrations.AddPlayerTurnColumn do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :player_turn, :string
    end
  end
end
