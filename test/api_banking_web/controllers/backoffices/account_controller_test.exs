defmodule ApiBankingWeb.Backoffices.AccountControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Backoffices
  alias ApiBanking.Backoffices.Account

  @create_attrs %{
    password_hashed: "some password_hashed"
  }
  @update_attrs %{
    password_hashed: "some updated password_hashed"
  }
  @invalid_attrs %{password_hashed: nil}

  def fixture(:account) do
    {:ok, account} = Backoffices.create_account(@create_attrs)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.backoffices_account_path(conn, :create), account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.backoffices_account_path(conn, :show, id))

      assert %{
               "id" => id,
               "password_hashed" => "some password_hashed"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.backoffices_account_path(conn, :create), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
