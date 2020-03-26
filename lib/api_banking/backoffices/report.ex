defmodule ApiBanking.Backoffices.Report do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "report" do
    field :day, :decimal
    field :month, :decimal
    field :year, :decimal
    field :total, :decimal
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:password_hashed])
    |> validate_required([:password_hashed])
  end
end
