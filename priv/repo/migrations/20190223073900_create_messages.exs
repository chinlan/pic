defmodule Pic.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :conversation_id, references(:conversations), null: false
      add :user_id, references(:users), null: false
      add :body, :text
      timestamps()
    end

    create index(:messages, [:conversation_id])
    create index(:messages, [:user_id])
  end
end
