defmodule Zapbot.Repo do
  use Ecto.Repo,
    otp_app: :zapbot,
    adapter: Ecto.Adapters.Postgres
end
