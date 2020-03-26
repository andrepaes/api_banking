defmodule ApiBankingWeb.Backoffices.ReportControllerTest do
  use ApiBankingWeb.ConnCase

  alias ApiBanking.Backoffices
  alias ApiBanking.Backoffices.Report

  @create_attrs %{
    password_hashed: "some password_hashed"
  }
  @update_attrs %{
    password_hashed: "some updated password_hashed"
  }
  @invalid_attrs %{password_hashed: nil}

  def fixture(:report) do
    {:ok, report} = Backoffices.create_report(@create_attrs)
    report
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create report" do
    test "renders report when data is valid", %{conn: conn} do
      conn = post(conn, Routes.backoffices_report_path(conn, :create), report: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.backoffices_report_path(conn, :show, id))

      assert %{
               "id" => id,
               "password_hashed" => "some password_hashed"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.backoffices_report_path(conn, :create), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_report(_) do
    report = fixture(:report)
    {:ok, report: report}
  end
end
