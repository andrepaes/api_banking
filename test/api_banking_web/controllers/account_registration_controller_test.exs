defmodule ApiBankingWeb.AccountRegistrationControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Accounts
  alias ApiBanking.Accounts.Account

  @create_attrs %{
    "name" => "André",
    "email" => "teste@gmail.com",
    "cpf" => "143.617.827-78",
    "phone" => "279993292959",
    "birthday_date" => "1993-07-06",
    "password" => "122222223"
  }

  @invalid_attrs %{
    "name" => "André",
    "email" => "teste@gmail.com",
    "cpf" => "143.617.827-78",
    "phone" => "279993292959",
    "birthday_date" => "1993-07-06",
    "password" => "122"
  }

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_registration_path(conn, :register), @create_attrs)
      response = json_response(conn, 201)["data"]
      assert String.replace(@create_attrs["cpf"], ~r/[^\d]/, "") == response["user_cpf"]
      assert @create_attrs["email"] == response["user_email"]
      assert @create_attrs["name"] == response["user_name"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_registration_path(conn, :register), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end