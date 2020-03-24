defmodule ApiBankingWeb.AccountRegistrationController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Accounts.Account
  alias ApiBanking.AccountsRegistration

  action_fallback ApiBankingWeb.FallbackController

  def register(conn, account_params) do
    with {:ok, %{account: account, user: user} = data} <-
           AccountsRegistration.register_account(account_params) do
      conn
      |> put_status(:created)
      |> render("show.json", data)
    end
  end
end
