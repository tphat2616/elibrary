defmodule Elibrary.Repo do
  use Ecto.Repo,
    otp_app: :elibrary,
    adapter: Ecto.Adapters.Postgres
end
