defmodule Pic.Repo.Migrations.CreatePostsTags do
  use Ecto.Migration

  def change do
    create table(:posts_tags) do
      add :post_id, references(:posts), null: false, index: true
      add :tag_id, references(:tags), null: false, index: true
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
    end
    create index(:posts_tags, [:post_id, :tag_id], uniq: true)
  end
end
