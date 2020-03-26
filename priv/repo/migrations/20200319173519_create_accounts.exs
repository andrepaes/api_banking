defmodule ApiBanking.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal, null: false
      add :password_hashed, :string
      timestamps()
      add :user_id, references(:users)
    end

    create constraint(:accounts, :balance_must_be_positive, check: "balance >= 0")
  end
end
