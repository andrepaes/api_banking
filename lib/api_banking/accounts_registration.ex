defmodule ApiBanking.AccountsRegistration do
  @moduledoc """
    The AccountsRegistration context
  """

  import Ecto.Query, warn: false

  alias ApiBanking.Accounts
  alias ApiBanking.Repo
  alias ApiBanking.Users
  alias Ecto.Multi

  def register_account(attrs) do
    Multi.new()
    |> Multi.run(:user, fn _repo, _ -> Users.create_user(attrs) end)
    |> Multi.run(:account, fn _repo, %{user: user} ->
      attrs = Map.put(attrs, "user_id", user.id)
      Accounts.create_account(attrs)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, account} ->
        {:ok, account}

      {:error, name, value, changes_so_far} ->
        {:error, value}
    end
  end
end
