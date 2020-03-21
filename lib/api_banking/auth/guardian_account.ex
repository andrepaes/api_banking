defmodule ApiBanking.Auth.GuardianAccount do
  use Guardian, otp_app: :api_banking
  alias ApiBanking.Accounts

  def subject_for_token(account, _claims) do
    {:ok, to_string(account.id)}
  end

  def resource_from_claims(claims) do
    resource = claims["sub"]
    |> Accounts.get_account!()
    {:ok, resource}
  end

end