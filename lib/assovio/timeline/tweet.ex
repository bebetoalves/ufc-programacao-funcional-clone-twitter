defmodule Assovio.Timeline.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :content, :string
    belongs_to :user, Assovio.Accounts.User

    timestamps()
  end

  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 280)
  end
end
