defmodule AssovioWeb.Plugs.SetCurrentUser do
  import Plug.Conn
  alias Assovio.Repo
  alias Assovio.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    if user_id do
      user =
        user_id
        |> Accounts.get_user!()
        |> Repo.preload(:following)

      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
