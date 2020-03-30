defmodule ApiBanking.Accounts.TransactionParams do
  @moduledoc """
    Trasaction query string params schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :period, :string
    field :date, :date
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:period, :date])
    |> validate_inclusion(:period, period_types(),
      message: "Valid period types: day, month, year and total"
    )
  end

  defp period_types do
    ["day", "month", "year", "total"]
  end
end
