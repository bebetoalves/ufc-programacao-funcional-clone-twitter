defmodule Assovio.Timeline.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    belongs_to :user, Assovio.Accounts.User
    belongs_to :tweet, Assovio.Timeline.Tweet

    timestamps()
  end

  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id, :tweet_id])
    |> validate_required([:user_id, :tweet_id])
    |> unique_constraint([:user_id, :tweet_id])
  end
end
