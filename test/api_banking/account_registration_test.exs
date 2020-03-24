defmodule ApiBanking.AccountRegistrationTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.AccountsRegistration

  use ExMachina

  @create_attrs %{
    "name" => sequence("Username"),
    "email" => sequence(:email, &"email-#{&1}@example.com"),
    "cpf" => Brcpfcnpj.cpf_generate(true),
    "phone" => "279993292959",
    "birthday_date" => "1993-07-06",
    "password" => "122222223"
  }

  @invalid_attrs_user %{
    "name" => "André",
    "email" => "testegmail.com",
    "cpf" => "143.6177.827-78",
    "phone" => "279993292959",
    "birthday_date" => "1993-07-06",
    "password" => "12345678"
  }

  @invalid_attrs_account %{
    "name" => "André",
    "email" => "teste@gmail.com",
    "cpf" => "143.617.827-78",
    "phone" => "279993292959",
    "birthday_date" => "1993-07-06",
    "password" => "122"
  }

  test "register_account/1 with a valid data create a user and account associate" do
    assert {:ok, %{account: account, user: user}} =
             AccountsRegistration.register_account(@create_attrs)
  end

  test "register_account/1 with invalid user data generate changeset error" do
    assert {:error, %Ecto.Changeset{}} =
             AccountsRegistration.register_account(@invalid_attrs_user)
  end

  test "register_account/1 with invalid account data generate changeset error" do
    assert {:error, %Ecto.Changeset{}} =
             AccountsRegistration.register_account(@invalid_attrs_account)
  end
end
