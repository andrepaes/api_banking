defmodule ApiBanking.AccountsTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Accounts
  alias ApiBanking.Users

  describe "accounts" do
    alias ApiBanking.Accounts.Account

    @valid_attrs %{
      password: "12345678"
    }

    @invalid_attrs %{
      password: "1234678"
    }

    @user_attrs %{
      "name" => "André",
      "email" => "teste@gmail.com",
      "cpf" => "143.617.827-78",
      "phone" => "279993292959",
      "birthday_date" => "1993-07-06"
    }

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    defp create_user do
      {:ok, user} = Users.create_user(@user_attrs)
      user
    end

    test "get_account!/1 returns the account with given id" do
      user = create_user()
      account = account_fixture(%{user_id: user.id})
      assert Map.get(Accounts.get_account!(account.id), :id) == account.id
    end

    test "create_account/1 with valid data creates a account" do
      user = create_user()

      assert {:ok, %Account{} = account} =
               Accounts.create_account(Map.put(@valid_attrs, :user_id, user.id))
    end

    test "create_account/1 with invalid data returns error changeset" do
      user = create_user()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_account(Map.put(@invalid_attrs, :user_id, user.id))
    end

    test "change_account/1 returns a account changeset" do
      user = create_user()
      account = account_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "transactions" do
    alias ApiBanking.Accounts.Transaction

#    @valid_attrs %{}
#    @update_attrs %{}
#    @invalid_attrs %{}
#
#    def transaction_fixture(attrs \\ %{}) do
#      {:ok, transaction} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Accounts.create_transaction()
#
#      transaction
#    end

#    test "list_transactions/0 returns all transactions" do
#      transaction = transaction_fixture()
#      assert Accounts.list_transactions() == [transaction]
#    end
#
#    test "get_transaction!/1 returns the transaction with given id" do
#      transaction = transaction_fixture()
#      assert Accounts.get_transaction!(transaction.id) == transaction
#    end
#
#    test "create_transaction/1 with valid data creates a transaction" do
#      assert {:ok, %Transaction{} = transaction} = Accounts.create_transaction(@valid_attrs)
#    end
#
#    test "create_transaction/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Accounts.create_transaction(@invalid_attrs)
#    end
#
#    test "change_transaction/1 returns a transaction changeset" do
#      transaction = transaction_fixture()
#      assert %Ecto.Changeset{} = Accounts.change_transaction(transaction)
#    end
  end
end
