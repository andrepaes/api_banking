defmodule ApiBanking.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias ApiBanking.Repo
  alias Comeonin.Argon2
  alias ApiBanking.Accounts.Account

  def authenticate_account(account_id, plain_text_password) do
    Repo.get(account_id)
    |> check_account_password(plain_text_password)
  end

  defp check_account_password(nil, _), do: {:error, "Incorrect username or password"}
  defp check_account_password(account, plain_text_password) do
    case Argon2.checkpw(plain_text_password, account.password) do
      true -> {:ok, account}
      false -> {:error, "Incorrect username or password"}
    end
  end
end
