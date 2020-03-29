defmodule ApiBankingWeb.Backoffices.ReportControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Backoffices
  alias ApiBanking.Auth.GuardianBackoffice
  alias ApiBanking.Accounts
  alias ApiBanking.AccountFactory

  @valid_attrs %{
    username: "andre_paes",
    password: "12345678"
  }

  def fixture(:account) do
    {:ok, account} = Backoffices.create_account(@valid_attrs)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "report/2 return the total transitioned on system", %{conn: conn} do
    account = fixture(:account)
    #setup transactions
    {:ok, datetime, 0} = DateTime.from_iso8601("2018-06-23T00:00:00Z")
    amount_2018 = create_transactions(datetime)

    {:ok, datetime, 0} = DateTime.from_iso8601("2018-11-06T00:00:00Z")
    amount_2018_1 = create_transactions(datetime)

    {:ok, datetime, 0} = DateTime.from_iso8601("2019-11-06T00:00:00Z")
    amount_2019 = create_transactions(datetime)

    {:ok, token, _} = GuardianBackoffice.encode_and_sign(account, %{}, token_type: :access)

    req_conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> get(Routes.backoffice_report_path(conn, :report, %{"date" => "2018-01-01", "period" => "year"}))

    response = json_response(req_conn, 200)

    assert Decimal.cast(response["total"]) == Decimal.add(amount_2018, amount_2018_1)

    req_conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> get(Routes.backoffice_report_path(conn, :report, %{"date" => "2018-11-06", "period" => "day"}))

    response = json_response(req_conn, 200)

    assert Decimal.cast(response["total"]) == amount_2018_1

    req_conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> get(Routes.backoffice_report_path(conn, :report, %{"date" => "2019-01-01", "period" => "year"}))

    response = json_response(req_conn, 200)

    assert Decimal.cast(response["total"]) == amount_2019

    req_conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> get(Routes.backoffice_report_path(conn, :report, %{"date" => "2018-06-10", "period" => "month"}))

    response = json_response(req_conn, 200)

    assert Decimal.cast(response["total"]) == amount_2018

    req_conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> get(Routes.backoffice_report_path(conn, :report, %{"period" => "total"}))

    response = json_response(req_conn, 200)

    assert Decimal.cast(response["total"]) == Decimal.add(Decimal.add(amount_2018, amount_2018_1), amount_2019)
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

end
