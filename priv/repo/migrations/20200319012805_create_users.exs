defmodule ApiBanking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :cpf, :string
      add :phone, :string
      add :birthday_date, :date
      timestamps()
    end

    create unique_index(:users, :cpf)
    create unique_index(:users, :email)

  end
end
