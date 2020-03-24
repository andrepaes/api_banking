defmodule ApiBanking.Users.User do
  @moduledoc """
    User schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :cpf, :string
    field :phone, :string
    field :birthday_date, :date
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :cpf,
      :phone,
      :birthday_date
    ])
    |> validate_required([
      :name,
      :email,
      :cpf,
      :phone,
      :birthday_date
    ])
    |> validate_format(:email, ~r/@/)
    |> update_change(:cpf, &String.replace(&1, ~r/[^\d]/, ""))
    |> validate_length(:cpf, min: 11, max: 11)
    |> unique_constraint(:cpf)
    |> unique_constraint(:email)
  end
end
