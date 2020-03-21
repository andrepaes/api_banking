defmodule ApiBanking.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias ApiBanking.Repo
  alias ApiBanking.Accounts.Account

  def authenticate_account(account_id, plain_text_password) do
    Repo.get(Account, account_id)
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
