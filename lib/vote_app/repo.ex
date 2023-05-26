defmodule VoteApp.Repo do
  use Ecto.Repo,
    otp_app: :vote_app,
    adapter: Ecto.Adapters.Postgres
end
