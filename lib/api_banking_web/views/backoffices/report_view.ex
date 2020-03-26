defmodule ApiBankingWeb.Backoffices.ReportView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.Backoffices.ReportView

  def render("index.json", %{backoffice_account: backoffice_account}) do
    %{data: render_many(backoffice_account, ReportView, "report.json")}
  end

  def render("show.json", %{report: report}) do
    %{data: render_one(report, ReportView, "report.json")}
  end

  def render("report.json", %{report: report}) do
    %{id: report.id,
      password_hashed: report.password_hashed}
  end
end
