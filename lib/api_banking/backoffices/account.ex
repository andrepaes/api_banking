defmodule ApiBanking.Backoffices.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "backoffice_account" do
    field :username, :string
    field :password_hashed, :string
    timestamps()

    field :password, :string, virtual: true
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:password, :username])
    |> validate_required([:password, :username])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.change(changeset, password_hashed: Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
