defmodule ApiBanking.UsersTest do
  use ApiBanking.DataCase

  alias ApiBanking.Users

  describe "users" do
    alias ApiBanking.Users.User

    @valid_attrs %{
      name: "Teste",
      email: "teste123@gmail.com",
      cpf: "14461782778",
      phone: "999392959",
      birthday_date: "2019-06-07"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.name == @valid_attrs[:name]
      assert user.email == @valid_attrs[:email]
      assert user.cpf == @valid_attrs[:cpf]
      assert user.phone == @valid_attrs[:phone]
      assert Date.to_string(user.birthday_date) == @valid_attrs[:birthday_date]
    end
  end
end
