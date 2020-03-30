defmodule ApiBankingWeb.Backoffices.AccountControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Auth.GuardianBackoffice
  alias ApiBanking.Backoffices

  @valid_attrs %{
    username: "andre_paes",
    password: "12345678"
  }

  @create_attrs %{
    "username" => "andrepaes",
    "password" => "12345678"
  }

  def fixture(:account) do
    {:ok, account} = Backoffices.create_account(@valid_attrs)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "create/2 create account and return username", %{conn: conn} do
    create_req =
      conn
      |> post(Routes.backoffice_account_path(conn, :create), @create_attrs)

    response = json_response(create_req, 201)["data"]
    assert response["username"] == @create_attrs["username"]
  end

  test "sign_in/2 generate a valid token when account data is correct", %{conn: conn} do
    account = fixture(:account)

    conn =
      conn
      |> post(Routes.backoffice_account_path(conn, :sign_in), %{
        "username" => account.username,
        "password" => "12345678"
      })

    response = json_response(conn, 200)["data"]

    assert Map.has_key?(response, "access_token")
  end

  test "sign_out/2 revoke the token", %{conn: conn} do
    account = fixture(:account)
    {:ok, token, _} = GuardianBackoffice.encode_and_sign(account, %{}, token_type: :access)

    response_conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> post(Routes.backoffice_account_path(conn, :sign_out))

    assert Map.get(response_conn, :status) == 204

    conn =
      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> post(Routes.backoffice_account_path(conn, :sign_out))

    assert Map.get(conn, :status) == 401
  end
end
