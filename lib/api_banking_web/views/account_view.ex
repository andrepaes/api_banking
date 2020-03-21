defmodule ApiBankingWeb.AccountView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.AccountView

  def render("login.json", %{account_id: account_id, token: token}) do
    %{
      account_id: account_id,
      access_token: token
    }
  end

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id}
  end
end
