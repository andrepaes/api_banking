defmodule ApiBankingWeb.Backoffices.AccountView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.Backoffices.AccountView

  def render("index.json", %{backoffice_account: backoffice_account}) do
    %{data: render_many(backoffice_account, AccountView, "account.json")}
  end

  def render("login.json", %{account_id: account_id, token: token}) do
    %{
      data: %{
        account_id: account_id,
        access_token: token
      }
    }
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      username: account.username
    }
  end
end
