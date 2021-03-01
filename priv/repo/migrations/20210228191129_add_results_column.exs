defmodule CodeName.Repo.Migrations.AddResultsColumn do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :current_results, {:array, :string}
    end
  end
end
