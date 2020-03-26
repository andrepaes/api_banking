defmodule ApiBanking.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false

  alias ApiBanking.Accounts.Account
  alias ApiBanking.Backoffices.Account, as: BackofficeAccount
  alias ApiBanking.Repo

  def authenticate_account(account_id, plain_text_password) do
    Repo.get(Account, account_id)
    |> check_account_password(plain_text_password)
  end

  def authenticate_backoffice(username, plain_text_password) do
    Repo.get_by(BackofficeAccount, username: username)
    |> check_account_password(plain_text_password)
  end

  defp check_account_password(nil, _), do: {:error, "Incorrect username or password"}

  defp check_account_password(account, plain_text_password) do
    case Argon2.verify_pass(plain_text_password, account.password_hashed) do
      true -> {:ok, account}
      false -> {:error, "Incorrect username or password"}
    end
  end
end
