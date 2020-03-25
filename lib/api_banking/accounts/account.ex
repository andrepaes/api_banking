defmodule ApiBanking.Accounts.Account do
  @moduledoc """
    Account schema
  """

  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  import Ecto.Changeset

  alias ApiBanking.Accounts.Account
  alias ApiBanking.Users.User
  alias Argon2
  alias Decimal

  schema "accounts" do
    field :balance, :decimal, read_after_writes: true
    field :password_hashed, :string
    timestamps()
    belongs_to :user, User

    field :password, :string, virtual: true
    field :amount, :decimal, virtual: true
  end

  @doc false
  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:password, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:password, :user_id])
    |> validate_length(:password, min: 8)
    |> put_pass_hash()
    |> put_initial_funds()
  end

  @doc false
  def withdraw_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> debit_amount()
    |> validate_number(:balance, greater_than_or_equal_to: 0, message: "account balance can't be negative")
    |> check_constraint(:balance, name: :balance_must_be_positive, message: "account balance can't be negative")
  end

  @doc false
  def deposit_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than: 0)
    |> deposit_amount()
  end

  defp deposit_amount(%Ecto.Changeset{valid?: true, changes: %{amount: amount}} = changeset) do
    balance = fetch_field!(changeset, :balance)
    Ecto.Changeset.change(changeset, balance: Decimal.add(balance, amount))
  end

  defp deposit_amount(changeset), do: changeset

  defp debit_amount(%Ecto.Changeset{valid?: true, changes: %{amount: amount}} = changeset) do
    balance = fetch_field!(changeset, :balance)
    Ecto.Changeset.change(changeset, balance: Decimal.sub(balance, amount))
  end

  defp debit_amount(changeset), do: changeset

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.change(changeset, password_hashed: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp put_initial_funds(%Ecto.Changeset{valid?: true} = changeset) do
    Ecto.Changeset.change(changeset, balance: Decimal.cast(1000.00))
  end

  defp put_initial_funds(changeset), do: changeset
end
