defmodule ApiBanking.BackofficesTest do
  use ApiBanking.DataCase

  alias ApiBanking.Backoffices
  alias ApiBanking.AccountFactory
  alias ApiBanking.Accounts

  describe "backoffice_account" do
    alias ApiBanking.Backoffices.Account

    @valid_attrs %{
      username: "andre_paes",
      password: "12345678"
    }

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Backoffices.create_account()

      account
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Map.get(Backoffices.get_account!(account.id), :id) == account.id
      assert Map.get(Backoffices.get_account!(account.id), :username) == account.username
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Backoffices.create_account(@valid_attrs)
      assert account.username == @valid_attrs[:username]
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Backoffices.change_account(account)
    end

    defp create_transactions(date) do
      account = AccountFactory.insert(:account)
      Enum.reduce(0..10, fn _, acc -> create_transaction(date, account, acc) end)
    end

    defp create_transaction(date, account, acc) do
      amount = :random.uniform(275)
      attrs = %{
        "type" => Enum.random(["transfer", "withdraw", "bonus_to_new_clients"]),
        "value" => amount,
        "money_flow" => "out",
        "account_id" => account.id,
        "inserted_at" => date
      }
      Accounts.create_transaction(attrs)
      Decimal.add(acc, amount)
    end

    test "get_report/1 returns total of transactions" do
      {:ok, datetime, 0} = DateTime.from_iso8601("2018-06-23T00:00:00Z")
      amount_2018 = create_transactions(datetime)

      {:ok, datetime, 0} = DateTime.from_iso8601("2018-07-03T00:00:00Z")
      amount_2018_1 = create_transactions(datetime)

      {:ok, datetime, 0} = DateTime.from_iso8601("2019-12-15T00:00:00Z")
      amount_2019 = create_transactions(datetime)

      assert Backoffices.get_report(%{"date" => "2018-06-23", "period" => "day"}) == {:ok, amount_2018}
      assert Backoffices.get_report(%{"date" => "2018-06-23", "period" => "month"}) == {:ok, amount_2018}

      assert Backoffices.get_report(%{"date" => "2018-07-03", "period" => "day"}) == {:ok, amount_2018_1}
      assert Backoffices.get_report(%{"date" => "2018-07-03", "period" => "month"}) == {:ok, amount_2018_1}

      #month lower than 10
      assert Backoffices.get_report(%{"date" => "2018-07-03", "period" => "year"})
             == {:ok, Decimal.add(amount_2018, amount_2018_1)}
      #month upper than 9
      assert Backoffices.get_report(%{"date" => "2018-10-13", "period" => "year"})
             == {:ok, Decimal.add(amount_2018, amount_2018_1)}

      total = Decimal.add(Decimal.add(amount_2018, amount_2018_1), amount_2019)
      assert Backoffices.get_report(%{"period" => "total"})
             == {:ok, total}

      assert Backoffices.get_report(%{}) == {:ok, total}
    end
  end
end
