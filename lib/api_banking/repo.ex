defmodule ApiBanking.Repo do
  use Ecto.Repo,
    otp_app: :api_banking,
    adapter: Ecto.Adapters.Postgres
end
