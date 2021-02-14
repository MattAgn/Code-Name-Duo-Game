defmodule CodeName.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :players, {:array, :string}

      timestamps()
    end

  end
end
