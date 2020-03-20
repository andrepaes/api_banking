defmodule ApiBankingWeb.AccountRegistrationView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.AccountRegistrationView

  def render("show2.json", %{account: account, user: user}) do
    %{data: render_one(%{
      account: account,
      user: user}, AccountRegistrationView, "test.json")}
  end

  def render("test.json", %{account_registration: account_registration}) do
    %{account: account, user: user} = account_registration
    %{
      account_id: account.id,
      account_balance: account.balance,
      user_name: user.name,
      user_email: user.email
    }
  end
end
