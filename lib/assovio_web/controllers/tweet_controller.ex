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
end
