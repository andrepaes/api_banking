defmodule ApiBanking.AuthTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Auth

  describe "tests" do
    alias ApiBanking.Auth.Account

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

#    def account_fixture(attrs \\ %{}) do
#      {:ok, account} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Auth.create_account()
#
#      account
#    end

#    test "list_tests/0 returns all tests" do
#      account = account_fixture()
#      assert Auth.list_tests() == [account]
#    end
#
#    test "get_account!/1 returns the account with given id" do
#      account = account_fixture()
#      assert Auth.get_account!(account.id) == account
#    end
#
#    test "create_account/1 with valid data creates a account" do
#      assert {:ok, %Account{} = account} = Auth.create_account(@valid_attrs)
#    end
#
#    test "create_account/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Auth.create_account(@invalid_attrs)
#    end
#
#    test "update_account/2 with valid data updates the account" do
#      account = account_fixture()
#      assert {:ok, %Account{} = account} = Auth.update_account(account, @update_attrs)
#    end
#
#    test "update_account/2 with invalid data returns error changeset" do
#      account = account_fixture()
#      assert {:error, %Ecto.Changeset{}} = Auth.update_account(account, @invalid_attrs)
#      assert account == Auth.get_account!(account.id)
#    end
#
#    test "delete_account/1 deletes the account" do
#      account = account_fixture()
#      assert {:ok, %Account{}} = Auth.delete_account(account)
#      assert_raise Ecto.NoResultsError, fn -> Auth.get_account!(account.id) end
#    end
#
#    test "change_account/1 returns a account changeset" do
#      account = account_fixture()
#      assert %Ecto.Changeset{} = Auth.change_account(account)
#    end
  end
end
