defmodule ApiBankingWeb.AccountControllerTest do
  use ApiBankingWeb.ConnCase, async: true

  alias ApiBanking.Accounts

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:account) do
    {:ok, account} = Accounts.create_account(@create_attrs)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
