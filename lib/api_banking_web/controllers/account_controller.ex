defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Auth
  alias ApiBanking.Auth.GuardianAccount
  alias ApiBanking.Accounts
  alias ApiBanking.Accounts.Account

  action_fallback ApiBankingWeb.FallbackController

  def sign_in(conn, %{"account_id" => account_id, "password" => password}) do
    case Auth.authenticate_account(account_id, password) do
      {:ok, account} ->
        with {:ok, token, _claims} <- GuardianAccount.encode_and_sign(account) do
          conn
          |> render("login.json", %{account_id: account.id, token: token})
        end
      {:error, msg} -> {:error, :unauthorized}
    end
  end

  def sign_out(conn, _params) do
    conn
    |> GuardianAccount.Plug.sign_out()
    |> send_resp(:no_content, "")
  end

  def transfer(conn, %{"id" => id, "transfer_to" => transfer_to}) do
    account = Accounts.get_account!(id)
    with {:ok, %Account{} = account} <- Accounts.transfer_money(account, transfer_to) do
      render(conn, "show.json", account: account)
    end
  end

  def withdraw(conn, %{"amount" => amount}) do
    account = GuardianAccount.Plug.current_resource(conn)
    with {:ok, %Account{}} <- Accounts.withdraw_money(account, amount) do
      render(conn, "show.json", account: account)
    end
  end
end
