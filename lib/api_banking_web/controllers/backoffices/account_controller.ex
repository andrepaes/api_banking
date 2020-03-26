defmodule ApiBankingWeb.Backoffices.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Auth
  alias ApiBanking.Auth.GuardianBackoffice
  alias ApiBanking.Backoffices
  alias ApiBanking.Backoffices.Account

  action_fallback ApiBankingWeb.FallbackController

  def create(conn, account_params) do
    with {:ok, %Account{} = account} <- Backoffices.create_account(account_params) do
      conn
      |> put_status(:created)
      |> render("show.json", account: account)
    end
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case Auth.authenticate_backoffice(username, password) do
      {:ok, account} ->
        with {:ok, token, _claims} <- GuardianBackoffice.encode_and_sign(account) do
          conn
          |> render("login.json", %{account_id: account.id, token: token})
        end
      {:error, msg} ->
        {:error, :unauthorized}
    end
  end

  def sign_out(conn, _params) do

  end
end
