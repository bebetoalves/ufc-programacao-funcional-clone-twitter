defmodule AssovioWeb.UserController do
  use AssovioWeb, :controller
  alias Assovio.Accounts
  alias Assovio.Timeline

  def new(conn, _params) do
    changeset = Accounts.User.changeset(%Accounts.User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Usuário criado com sucesso!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    tweets = Timeline.list_user_tweets(user.id)
    render(conn, "show.html", user: user, tweets: tweets)
  end

  def follow(conn, %{"id" => id}) do
    user_to_follow = Accounts.get_user!(id)
    current_user = conn.assigns.current_user

    case Accounts.follow_user(current_user, user_to_follow) do
      {:ok, _} ->
        redirect(conn, to: Routes.user_path(conn, :show, user_to_follow))

      {:error, _} ->
        put_flash(conn, :error, "Erro ao seguir usuário!")
        redirect(conn, to: Routes.user_path(conn, :show, user_to_follow))
    end
  end

  def search(conn, %{"q" => query}) when is_binary(query) and query != "" do
    users = Accounts.search_users(query)
    render(conn, "search.html", users: users, query: query)
  end

  def search(conn, _) do
    users = []
    render(conn, "search.html", users: users, query: "")
  end

  def unfollow(conn, %{"id" => id}) do
    user_to_unfollow = Accounts.get_user!(id)

    case Accounts.unfollow_user(conn.assigns.current_user, user_to_unfollow) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Você deixou de seguir #{user_to_unfollow.name}!")
        |> redirect(to: Routes.user_path(conn, :show, user_to_unfollow))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Não foi possível deixar de seguir este usuário!")
        |> redirect(to: Routes.user_path(conn, :show, user_to_unfollow))
    end
  end
end
