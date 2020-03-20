defmodule ApiBankingWeb.AccountRegistrationView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.AccountRegistrationView

  def render("show.json", %{account: account, user: user}) do
    %{data: render_one(%{
      account: account,
      user: user}, AccountRegistrationView, "account.json")}
  end

  def render("account.json", %{account_registration: account_registration}) do
    %{account: account, user: user} = account_registration
    %{
      account_id: account.id,
      account_balance: account.balance,
      user_name: user.name,
      user_email: user.email,
      user_cpf: user.cpf
    }
  end
end
