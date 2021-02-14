defmodule CodeName.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :word, :string

      timestamps()
    end

  end
end
