defmodule ApiBankingWeb.Backoffices.ReportController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Backoffices
  alias ApiBanking.Backoffices.Report

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    backoffice_account = Backoffices.list_backoffice_account()
    render(conn, "index.json", backoffice_account: backoffice_account)
  end

  def create(conn, %{"report" => report_params}) do
    with {:ok, %Report{} = report} <- Backoffices.create_report(report_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.backoffices_report_path(conn, :show, report))
      |> render("show.json", report: report)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Backoffices.get_report!(id)
    render(conn, "show.json", report: report)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Backoffices.get_report!(id)

    with {:ok, %Report{} = report} <- Backoffices.update_report(report, report_params) do
      render(conn, "show.json", report: report)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Backoffices.get_report!(id)

    with {:ok, %Report{}} <- Backoffices.delete_report(report) do
      send_resp(conn, :no_content, "")
    end
  end
end
