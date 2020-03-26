defmodule ApiBanking.Repo.Migrations.CreateBackofficeAccount do
  use Ecto.Migration

  def change do
    create table(:backoffice_account) do
      add :username, :string
      add :password_hashed, :string
      timestamps()
    end

    create unique_index(:backoffice_account, :username)

  end
end
