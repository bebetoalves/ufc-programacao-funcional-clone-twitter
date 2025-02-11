defmodule AssovioWeb.PageController do
  use AssovioWeb, :controller
  alias Assovio.Timeline

  def index(conn, _params) do
    tweets =
      case conn.assigns.current_user do
        nil -> []
        user -> Timeline.list_timeline_tweets(user)
      end

    render(conn, "index.html", tweets: tweets)
  end
end
