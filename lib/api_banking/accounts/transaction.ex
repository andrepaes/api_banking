defmodule ApiBanking.Accounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  alias ApiBanking.Accounts.Account

  schema "transactions" do
    field :type, :string
    field :money_flow, :string
    field :value, :decimal
    timestamps(updated_at: false)
    belongs_to :account, Account
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:type, :value, :money_flow, :account_id])
    |> validate_required([:type, :value, :money_flow, :account_id])
    |> validate_inclusion(:type, transaction_types(), message: "this operation isn't permitted")
    |> validate_inclusion(:money_flow, money_flow_types(), message: "this flow isn't permitted")
  end

  defp transaction_types do
    ["transfer", "withdraw"]
  end

  defp money_flow_types do
    ["in", "out"]
  end
end
