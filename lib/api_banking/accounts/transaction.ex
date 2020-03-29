defmodule ApiBanking.Accounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]
  @env Mix.env()
  alias ApiBanking.Accounts.Account

  schema "transactions" do
    field :type, :string
    field :money_flow, :string
    field :value, :decimal
    timestamps(updated_at: false)
    belongs_to :account, Account
  end

  @doc false
  def changeset(transaction, attrs) when @env == :test do
    transaction
    |> cast(attrs, [:type, :value, :money_flow, :account_id, :inserted_at])
    |> validate_required([:type, :value, :money_flow, :account_id])
    |> validate_inclusion(:type, transaction_types(), message: "this operation isn't permitted")
    |> validate_inclusion(:money_flow, money_flow_types(), message: "this flow isn't permitted")
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
    ["transfer", "withdraw", "bonus_to_new_clients"]
  end

  defp money_flow_types do
    ["in", "out"]
  end
end
