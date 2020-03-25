defmodule ApiBanking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :cpf, :string, null: false
      add :phone, :string, null: false
      add :birthday_date, :date, null: false
      timestamps()
    end

    create unique_index(:users, :cpf)
    create unique_index(:users, :email)
  end
end
