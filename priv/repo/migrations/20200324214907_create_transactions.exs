defmodule ApiBanking.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :string, null: false
      add :money_flow, :string, null: false
      add :value, :decimal, null: false
      timestamps(updated_at: false)
      add :account_id, references(:accounts), null: false
    end
  end
end
