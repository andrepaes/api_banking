defmodule ApiBankingWeb.Backoffices.ReportController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Backoffices

  action_fallback ApiBankingWeb.FallbackController

  def report(conn, params) do
    with {:ok, report} <- Backoffices.get_report(params) do
      render(conn, "report.json", report: report)
    end
  end
end
