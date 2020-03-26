defmodule ApiBanking.BackofficesTest do
  use ApiBanking.DataCase

  alias ApiBanking.Backoffices

  describe "backoffice_account" do
    alias ApiBanking.Backoffices.Report

    @valid_attrs %{password_hashed: "some password_hashed"}
    @update_attrs %{password_hashed: "some updated password_hashed"}
    @invalid_attrs %{password_hashed: nil}

    def report_fixture(attrs \\ %{}) do
      {:ok, report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Backoffices.create_report()

      report
    end


    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Backoffices.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Backoffices.create_report(@valid_attrs)
      assert report.password_hashed == "some password_hashed"
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Backoffices.create_report(@invalid_attrs)
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Backoffices.change_report(report)
    end
  end

  describe "backoffice_account" do
    alias ApiBanking.Backoffices.Account

    @valid_attrs %{password_hashed: "some password_hashed"}
    @update_attrs %{password_hashed: "some updated password_hashed"}
    @invalid_attrs %{password_hashed: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Backoffices.create_account()

      account
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Backoffices.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Backoffices.create_account(@valid_attrs)
      assert account.password_hashed == "some password_hashed"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Backoffices.create_account(@invalid_attrs)
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Backoffices.change_account(account)
    end
  end
end
