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
        |> put_flash(:error, "Erro ao criar assovio!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def like(conn, %{"id" => id}) do
    case Timeline.like_tweet(conn.assigns.current_user.id, id) do
      {:ok, _like} ->
        redirect(conn, to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Não foi possível curtir o assovio!")
        |> redirect(to: "/")
    end
  end

  def unlike(conn, %{"id" => id}) do
    case Timeline.unlike_tweet(conn.assigns.current_user.id, id) do
      {1, _} ->
        redirect(conn, to: "/")

      _ ->
        conn
        |> put_flash(:error, "Não foi possível descurtir o assovio!")
        |> redirect(to: "/")
    end
  end

  def retweet(conn, %{"id" => id}) do
    case Timeline.retweet(conn.assigns.current_user.id, id) do
      {:ok, _tweet} ->
        redirect(conn, to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Não foi possível reassoviar!")
        |> redirect(to: "/")
    end
  end

  @spec undo_retweet(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def undo_retweet(conn, %{"id" => id}) do
    {deleted, _} = Timeline.undo_retweet(conn.assigns.current_user.id, id)

    if deleted > 0 do
      redirect(conn, to: "/")
    else
      conn
      |> put_flash(:error, "Não foi possível desfazer o reassovio!")
      |> redirect(to: "/")
    end
  end

  def delete(conn, %{"id" => id}) do
    tweet = Timeline.get_tweet!(id)

    if tweet.user_id == conn.assigns.current_user.id do
      Timeline.delete_tweet(tweet)

      conn
      |> put_flash(:info, "Assovio apagado com sucesso!")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "Você não pode apagar este assovio!")
      |> redirect(to: "/")
    end
  end
end
