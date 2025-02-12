defmodule Assovio.Timeline do
  import Ecto.Query
  alias Assovio.Repo
  alias Assovio.Timeline.{Tweet, Like}

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
    Tweet
    |> where([t], t.user_id in ^Enum.map(user.following, & &1.id) or t.user_id == ^user.id)
    |> order_by(desc: :inserted_at)
    |> preload([:user, :likes])
    |> Repo.all()
  end

  def like_tweet(user_id, tweet_id) do
    %Like{}
    |> Like.changeset(%{user_id: user_id, tweet_id: tweet_id})
    |> Repo.insert()
  end

  def unlike_tweet(user_id, tweet_id) do
    from(l in Like, where: l.user_id == ^user_id and l.tweet_id == ^tweet_id)
    |> Repo.delete_all()
  end

  def liked_by_user?(tweet_id, user_id) do
    query =
      from l in Like,
        where: l.tweet_id == ^tweet_id and l.user_id == ^user_id

    Repo.exists?(query)
  end

  def count_likes(tweet_id) do
    from(l in Like, where: l.tweet_id == ^tweet_id)
    |> Repo.aggregate(:count)
  end
end
