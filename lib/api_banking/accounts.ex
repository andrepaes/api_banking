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
    Multi.new()
    |> Multi.run(:account, fn _repo, _ ->
      %Account{}
      |> Account.changeset(attrs)
      |> Repo.insert()
    end)
    |> Multi.run(:deposit, fn _repo, %{account: account} ->
      deposit_money(account, %{"amount" => 1000}, "bonus_to_new_clients")
    end)
    |> Repo.transaction()
    |> case do
      {:ok, response} ->
        {:ok, response.deposit.update}

      {:error, _name, value, _changes_so_far} ->
        {:error, value}
    end
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

  def transfer_money(emitter, %{"transfer_to" => transfer_to, "amount" => amount} = attrs) do
    receiver = get_account!(transfer_to)

    if emitter.id != receiver.id do
      Multi.new()
      |> Multi.run(:withdraw, fn _repo, _ -> withdraw_money(emitter, attrs, false, "transfer") end)
      |> Multi.run(:deposit, fn _repo, _ -> deposit_money(receiver, attrs, "transfer") end)
      |> Repo.transaction()
      |> case do
        {:ok, transaction} ->
          %{withdraw: emitter_updated} = transaction
          {:ok, emitter_updated.update}

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

  def withdraw_money(account, %{"amount" => amount} = attrs, send_email \\ true, transaction_type) do
    changeset =
      account
      |> Account.withdraw_changeset(attrs)

    Multi.new()
    |> Multi.run(:update, fn _repo, _ -> Repo.update(changeset) end)
    |> Multi.run(:transaction_out, fn _repo, _ ->
      create_transaction(%{
        account_id: account.id,
        type: transaction_type,
        money_flow: "out",
        value: amount
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok, account} when send_email ->
        # the email must be sent using Task.start to not block the process
        IO.puts("SEND EMAIL")
        {:ok, account.update}

      {:ok, account} ->
        {:ok, account}

      {:error, name, value, changes_so_far} ->
        {:error, value}
    end
  end

  def deposit_money(account, %{"amount" => amount} = attrs, transaction_type) do
    changeset =
      account
      |> Account.deposit_changeset(attrs)

    Multi.new()
    |> Multi.run(:update, fn _repo, _ -> Repo.update(changeset) end)
    |> Multi.run(:transfer_in, fn _repo, _ ->
      create_transaction(%{
        account_id: account.id,
        type: transaction_type,
        money_flow: "in",
        value: amount
      })
    end)
    |> Repo.transaction()
  end

  alias ApiBanking.Accounts.QueryFilters.TransactionFilters
  alias ApiBanking.Accounts.Transaction
  alias ApiBanking.Accounts.TransactionParams

  @doc """
  Returns the total amount of transactions.

  ## Examples

      iex> get_transactions_report()
      [%Transaction{}, ...]

  """
  def get_transactions_report(params) do
    query_params =
      %TransactionParams{}
      |> TransactionParams.changeset(params)
      |> case do
        %Ecto.Changeset{valid?: true, changes: changes} ->
          total =
            Transaction
            |> TransactionFilters.filter_period(changes)
            |> where(
              [t],
              t.money_flow == "out" or (t.money_flow == "in" and t.type != "transfer")
            )
            |> Repo.aggregate(:sum, :value)

          {:ok, total}

        changeset ->
          {:error, changeset}
      end
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
