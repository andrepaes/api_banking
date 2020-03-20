defmodule ApiBanking.Accounts.Account do
  @moduledoc """
    Account schema
  """
  @timestamps_opts [type: :utc_datetime]
  use Ecto.Schema
  import Ecto.Changeset
  alias ApiBanking.Users.User
  alias Argon2
  alias Decimal
  alias ApiBanking.Accounts.Account

  schema "accounts" do
    field :balance, :decimal
    field :password_hashed, :string
    timestamps()
    belongs_to :user, User
    field :password, :string, virtual: true
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

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.change(changeset, password_hashed: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp put_initial_funds(%Ecto.Changeset{valid?: true} = changeset) do
    Ecto.Changeset.change(changeset, balance: Decimal.cast(1000.00))
  end

  defp put_initial_funds(changeset), do: changeset

end
