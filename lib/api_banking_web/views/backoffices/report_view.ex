defmodule ApiBankingWeb.Backoffices.ReportView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.Backoffices.ReportView

  def render("report.json", %{report: total}) do
    %{total: total || 0}
  end
end
