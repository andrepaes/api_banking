defmodule ApiBanking.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias ApiBanking.Accounts.Account
  alias ApiBanking.Repo
  alias Ecto.Multi

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  @doc """
  Transfer money

  ## Examples

      iex> transfer_money(account, transfer_data)
      {:ok, %Account{}}

      iex> transfer_money(account, transfer_data)
      {:error, %Ecto.Changeset{}}

  """

  def transfer_money(emitter, %{"transfer_to" => transfer_to, "amount" => _} = attrs) do
    receiver = get_account!(transfer_to)

    if emitter.id != receiver.id do
      Multi.new()
      |> Multi.run(:withdraw, fn _repo, _ -> withdraw_money(emitter, attrs) end)
      |> Multi.run(:deposit, fn _repo, _ -> deposit_money(receiver, attrs) end)
      |> Repo.transaction()
      |> case do
        {:ok, transaction} ->
          %{withdraw: emitter_updated} = transaction
          {:ok, emitter_updated}

        {:error, _name, value, _changes_so_far} ->
          {:error, value}
      end
    else
      {:error, :unprocessable_entity, "to transfer money the emitter id's must be different"}
    end
  end

  @doc """
  Withdraw money

  ## Examples

      iex> withdraw_money(account, amount)
      {:ok, %Account{}}

      iex> withdraw_money(account, amount)
      {:error, %Ecto.Changeset{}}

  """

  def withdraw_money(account, %{"amount" => _} = attrs) do
    account
    |> Account.withdraw_changeset(attrs)
    |> Repo.update()
  end

  def deposit_money(account, %{"amount" => _} = attrs) do
    account
    |> Account.deposit_changeset(attrs)
    |> Repo.update()
  end
end
