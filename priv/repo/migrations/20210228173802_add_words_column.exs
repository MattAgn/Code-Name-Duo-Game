defmodule CodeName.Repo.Migrations.AddWordsColumn do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :words, {:array, :string}
    end
  end
end
