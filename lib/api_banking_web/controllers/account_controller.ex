defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Accounts
  alias ApiBanking.Accounts.Account
  alias ApiBanking.Auth
  alias ApiBanking.Auth.GuardianAccount

  action_fallback ApiBankingWeb.FallbackController

  def sign_in(conn, %{"account_id" => account_id, "password" => password}) do
    case Auth.authenticate_account(account_id, password) do
      {:ok, account} ->
        with {:ok, token, _claims} <- GuardianAccount.encode_and_sign(account) do
          conn
          |> render("login.json", %{account_id: account.id, token: token})
        end

      {:error, msg} ->
        {:error, :unauthorized}
    end
  end

  def sign_out(conn, _params) do
    conn
    |> GuardianAccount.Plug.sign_out()
    |> send_resp(:no_content, "")
  end

  def transfer(conn, %{"transfer_to" => transfer_to, "amount" => amount} = transfer_data) do
    emitter = GuardianAccount.Plug.current_resource(conn)

    with {:ok, %Account{} = account} <- Accounts.transfer_money(emitter, transfer_data) do
      render(conn, "show.json", account: account)
    end
  end

  def withdraw(conn, %{"amount" => _} = attrs) do
    account = GuardianAccount.Plug.current_resource(conn)

    with {:ok, %Account{} = account} <- Accounts.withdraw_money(account, attrs, true, "withdraw") do
      render(conn, "show.json", account: account)
    end
  end
end
