defmodule Assovio.Timeline.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :content, :string
    field :retweet, :boolean, default: false
    belongs_to :user, Assovio.Accounts.User
    belongs_to :original_tweet, Assovio.Timeline.Tweet
    has_many :likes, Assovio.Timeline.Like

    timestamps()
  end

  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:content, :user_id, :original_tweet_id, :retweet])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 280)
  end
end
