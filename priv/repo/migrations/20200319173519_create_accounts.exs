defmodule ApiBanking.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do

      timestamps()
    end

  end
end
