defmodule ApiBanking.Accounts.QueryFilters.TransactionFilters do
  @moduledoc """
    This module is to define the way a transaction's get request  alias ApiBanking.Accounts
    can be transformed by query params
  """

  import Ecto.Query

  def filter_period(query, %{period: period, date: date}),
    do: filter_period(query, String.to_atom(period), date)

  def filter_period(query, _), do: query

  defp filter_period(query, :day, date) do
    from t in query,
      where: fragment("date(date_trunc('day', ?))", t.inserted_at) == ^date
  end

  defp filter_period(query, :month, date) do
    formated_date = get_date_with_valid_month(date)

    from t in query,
      where: fragment("date(date_trunc('month', ?))", t.inserted_at) == ^formated_date
  end

  defp filter_period(query, :year, date) do
    {:ok, date} = Date.from_iso8601("#{date.year}-01-01")

    from t in query,
      where: fragment("date(date_trunc('year', ?))", t.inserted_at) == ^date
  end

  defp filter_period(query, _, _), do: query

  defp get_date_with_valid_month(date) do
    case date.month do
      val when val <= 9 ->
        {:ok, date} = Date.from_iso8601("#{date.year}-0#{date.month}-01")
        date

      _ ->
        {:ok, date} = Date.from_iso8601("#{date.year}-#{date.month}-01")
        date
    end
  end
end
