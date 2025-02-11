defmodule Assovio.Accounts do
  import Ecto.Query
  alias Assovio.Repo
  alias Assovio.Accounts.{User, Follow}

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:following)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def authenticate_user(email, password) do
    user = get_user_by_email(email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end

  def follow_user(current_user, user_to_follow) do
    # Verificar se já não está seguindo
    case Repo.get_by(Follow, follower_id: current_user.id, followed_id: user_to_follow.id) do
      nil ->
        %Follow{}
        |> Follow.changeset(%{
          follower_id: current_user.id,
          followed_id: user_to_follow.id
        })
        |> Repo.insert()

      _follow ->
        {:ok, current_user}
    end
  end

  def unfollow_user(current_user, user_to_unfollow) do
    case Repo.get_by(Follow, follower_id: current_user.id, followed_id: user_to_unfollow.id) do
      nil ->
        {:ok, current_user}

      follow ->
        Repo.delete(follow)
    end
  end

  def following?(current_user, user) do
    case Repo.get_by(Follow, follower_id: current_user.id, followed_id: user.id) do
      nil -> false
      _follow -> true
    end
  end

  def search_users(query) do
    search_term = "%#{query}%"

    User
    |> where([u], ilike(u.name, ^search_term) or ilike(u.email, ^search_term))
    |> limit(20)
    |> Repo.all()
    |> Repo.preload(:following)
  end
end
