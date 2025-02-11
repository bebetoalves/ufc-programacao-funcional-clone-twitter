defmodule Assovio.Repo do
  use Ecto.Repo,
    otp_app: :assovio,
    adapter: Ecto.Adapters.Postgres
end
