# priv/repo/migrations/TIMESTAMP_create_follows.exs
defmodule Assovio.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, references(:users, on_delete: :delete_all), null: false
      add :followed_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:follows, [:follower_id, :followed_id])
  end
end
