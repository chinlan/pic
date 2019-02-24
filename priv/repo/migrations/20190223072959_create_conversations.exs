defmodule Pic.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :sender_id, references(:users), null: false
      add :recipient_id, references(:users), null: false

      timestamps()
    end

    create index(:conversations, [:sender_id])
    create index(:conversations, [:recipient_id])
    create index(:conversations, [:sender_id, :recipient_id], uniq: true)
  end
end
