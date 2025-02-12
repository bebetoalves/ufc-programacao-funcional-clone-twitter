defmodule AssovioWeb.TweetController do
  use AssovioWeb, :controller
  alias Assovio.Timeline

  def create(conn, %{"tweet" => tweet_params}) do
    tweet_params = Map.put(tweet_params, "user_id", conn.assigns.current_user.id)

    case Timeline.create_tweet(tweet_params) do
      {:ok, _tweet} ->
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Erro ao criar assovio")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def like(conn, %{"id" => id}) do
    case Timeline.like_tweet(conn.assigns.current_user.id, id) do
      {:ok, _like} ->
        redirect(conn, to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Não foi possível curtir o tweet")
        |> redirect(to: "/")
    end
  end

  def unlike(conn, %{"id" => id}) do
    case Timeline.unlike_tweet(conn.assigns.current_user.id, id) do
      {1, _} ->
        redirect(conn, to: "/")

      _ ->
        conn
        |> put_flash(:error, "Não foi possível descurtir o tweet")
        |> redirect(to: "/")
    end
  end
end
