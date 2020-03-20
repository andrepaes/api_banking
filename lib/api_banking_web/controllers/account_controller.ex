defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Accounts
  alias ApiBanking.Accounts.Account

  action_fallback ApiBankingWeb.FallbackController

  def transfer(conn, %{"id" => id, "transfer_to" => transfer_to}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.transfer_money(account, transfer_to) do
      render(conn, "show.json", account: account)
    end
  end

  def withdraw(conn, %{"id" => id, "amount" => amount}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.withdraw_money(account) do
      render(conn, "show.json", account: account)
    end
  end
end
