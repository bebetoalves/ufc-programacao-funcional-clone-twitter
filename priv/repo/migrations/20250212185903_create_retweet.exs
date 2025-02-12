defmodule Assovio.Repo.Migrations.CreateRetweet do
  use Ecto.Migration

  def change do
    alter table(:tweets) do
      add :original_tweet_id, references(:tweets, on_delete: :delete_all)
      add :retweet, :boolean, default: false
    end

    create index(:tweets, [:original_tweet_id])
  end
end
