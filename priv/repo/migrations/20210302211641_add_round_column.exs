defmodule CodeName.Repo.Migrations.AddRoundColumn do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :current_round, :integer
    end
  end
end
