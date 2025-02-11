defmodule Assovio.Timeline do
  import Ecto.Query
  alias Assovio.Repo
  alias Assovio.Timeline.Tweet

  def create_tweet(attrs \\ %{}) do
    result =
      %Tweet{}
      |> Tweet.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, tweet} ->
        tweet = Repo.preload(tweet, :user)
        Phoenix.PubSub.broadcast(Assovio.PubSub, "tweets", {:new_tweet, tweet})
        {:ok, tweet}

      error ->
        error
    end
  end

  def list_user_tweets(user_id) do
    Tweet
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> preload(:user)
    |> Repo.all()
  end

  def list_timeline_tweets(user) do
    following_ids = Enum.map(user.following, & &1.id)

    Tweet
    |> where([t], t.user_id in ^following_ids or t.user_id == ^user.id)
    |> order_by(desc: :inserted_at)
    |> preload(:user)
    |> Repo.all()
  end
end
