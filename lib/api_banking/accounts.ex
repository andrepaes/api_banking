defmodule ApiBanking.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ApiBanking.Repo

  alias ApiBanking.Accounts.Account

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

      iex> transfer_money(account, transfer_to)
      {:ok, %Account{}}

      iex> transfer_money(account, transfer_to)
      {:error, %Ecto.Changeset{}}

  """

  def transfer_money(account, transfer_to) do

  end

  @doc """
  Withdraw money

  ## Examples

      iex> withdraw_money(account)
      {:ok, %Account{}}

      iex> withdraw_money(account, transfer_to)
      {:error, %Ecto.Changeset{}}

  """

  def withdraw_money(account) do

  end
end
