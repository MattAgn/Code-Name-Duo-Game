defmodule CodeName.Repo do
  use Ecto.Repo,
    otp_app: :code_name,
    adapter: Ecto.Adapters.Postgres
end
