defmodule AdminSuite.Repo do
  use Ecto.Repo,
    otp_app: :admin_suite,
    adapter: Ecto.Adapters.Postgres
end
