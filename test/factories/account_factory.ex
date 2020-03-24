defmodule ApiBanking.AccountFactory do
  @moduledoc """
    Account factory
  """
  use ExMachina.Ecto, repo: ApiBanking.Repo

  alias ApiBanking.Accounts.Account
  alias ApiBanking.Users.User
  alias Decimal

  def user_factory(_attrs) do
    %User{
      name: sequence("Username"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      cpf: Brcpfcnpj.cpf_generate(true),
      phone: "279993292959",
      birthday_date: "1993-07-06"
    }
  end

  def account_factory(attrs) do
    %Account{
      password: "12345678",
      password_hashed: Argon2.hash_pwd_salt("12345678"),
      balance: Decimal.from_float(1000.00),
      user: build(:user)
    }
  end
end
