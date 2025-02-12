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
    |> preload([:user, :likes, original_tweet: :user])
    |> Repo.all()
  end

  def list_timeline_tweets(user) do
    following_ids = Enum.map(user.following, & &1.id)

    Tweet
    |> preload([:user, :likes, original_tweet: :user])
    |> where([t], t.user_id in ^following_ids or t.user_id == ^user.id)
    |> order_by(desc: :inserted_at)
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

  def retweet(user_id, original_tweet_id) do
    original_tweet = get_tweet!(original_tweet_id)

    %Tweet{}
    |> Tweet.changeset(%{
      content: original_tweet.content,
      user_id: user_id,
      original_tweet_id: original_tweet_id,
      retweet: true
    })
    |> Repo.insert()
  end

  def undo_retweet(user_id, original_tweet_id) do
    from(t in Tweet,
      where:
        t.user_id == ^user_id and
          t.original_tweet_id == ^original_tweet_id and
          t.retweet == true
    )
    |> Repo.delete_all()
  end

  def retweeted_by_user?(original_tweet_id, user_id) do
    query =
      from t in Tweet,
        where:
          t.user_id == ^user_id and
            t.original_tweet_id == ^original_tweet_id and
            t.retweet == true

    Repo.exists?(query)
  end

  def get_tweet!(id), do: Repo.get!(Tweet, id)

  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end
end
