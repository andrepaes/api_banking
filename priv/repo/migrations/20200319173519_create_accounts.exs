defmodule ApiBanking.Repo.Migrations.CreateAccounts do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime]
  alias ApiBanking.Users.User
  def change do
    create table(:accounts) do
      add :balance, :decimal, null: false
      add :password_hashed, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()

    end
  end
end
