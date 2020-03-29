defmodule ApiBankingWeb.Backoffices.AccountControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Backoffices
  alias ApiBanking.Backoffices.Account

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

  test "sign_in/2 generate a valid token when account data is correct", %{conn: conn} do
    account = fixture(:account)
    conn =
      post(conn, "api/v1/backoffices/sign-in", %{
        "username" => account.username,
        "password" => "12345678"
      })
    response = json_response(conn, 200)["data"]

    assert Map.has_key?(response, "access_token")
  end
end
