defmodule ApiBanking.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [])
    |> validate_required([])
  end
end
