defmodule Helpers.CpfMask do
  @spec cpf_mask(String.t(), String.t()) :: String.t()
  def cpf_mask(pattern, input) do
    do_mask(pattern, input, "")
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
