defmodule Pic.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false, index: true
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
    end
  end
end
