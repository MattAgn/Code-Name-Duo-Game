defmodule CodeName.Repo.Migrations.AddGameStatusColumn do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :game_status, :string
    end
  end
end
