defmodule ApiBankingWeb.AccountView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.AccountView
  alias Decimal

  def render("login.json", %{account_id: account_id, token: token}) do
    %{
      data: %{
        account_id: account_id,
        access_token: token
      }
    }
  end

  def render("logout.json", _params) do
    %{
      message: "Account logged out"
    }
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      balance: account.balance
    }
  end
end
