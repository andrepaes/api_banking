defmodule Helpers.CpfMask do
  @moduledoc """
  Provides cpf mask functions.

  ## Examples

      iex> Helpers.CpfMask.cpf_mask("14461782678")
      144.617.826-78

  """
  @spec cpf_mask(String.t()) :: String.t()
  def cpf_mask(input) do
    do_mask("###.###.###-##", input, "")
  end

  @spec do_mask(String.t(), String.t(), String.t()) :: String.t()
  defp do_mask("#" <> rest_pattern, <<input, rest_input::bytes>>, acc) do
    do_mask(rest_pattern, rest_input, <<acc::bytes, input>>)
  end

  defp do_mask("." <> rest_pattern, input, acc) do
  do_mask(rest_pattern, input, <<acc::bytes, ".">>)
  end

  defp do_mask("-" <> rest_pattern, input, acc) do
    do_mask(rest_pattern, input, <<acc::bytes, "-">>)
  end

  defp do_mask(<<>>, _, acc), do: acc
end
