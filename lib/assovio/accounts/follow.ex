defmodule Assovio.Accounts.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "follows" do
    belongs_to :follower, Assovio.Accounts.User
    belongs_to :followed, Assovio.Accounts.User

    timestamps()
  end

  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :followed_id])
    |> validate_required([:follower_id, :followed_id])
    |> unique_constraint([:follower_id, :followed_id])
  end
end
