defmodule Pic.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :followee_id, references(:users, on_delete: :nothing)# need null: false
      add :follower_id, references(:users, on_delete: :nothing)# need null: false
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
    end

    create index(:follows, [:followee_id])
    create index(:follows, [:follower_id])
    create index(:follows, [:followee_id, :follower_id], uniq: true)
  end
end
