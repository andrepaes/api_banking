defmodule ApiBankingWeb.AccountRegistrationController do
  use ApiBankingWeb, :controller

  alias ApiBanking.AccountsRegistration
  alias ApiBanking.Accounts.Account

  action_fallback ApiBankingWeb.FallbackController

  def register(conn, account_params) do
    with {:ok, %{account: account, user: user} = data} <- AccountsRegistration.register_account(account_params) do
      render(conn, "show2.json", data)
    end
  end
end