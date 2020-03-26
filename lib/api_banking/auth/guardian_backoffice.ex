defmodule ApiBanking.Auth.GuardianBackoffice do
  @moduledoc """
    This is an authentication module build for backoffice context,
    so it'll provide way to auth req's with backoffice account id
  """
  use Guardian, otp_app: :api_banking
  alias ApiBanking.Backoffices

  def subject_for_token(account, _claims) do
    {:ok, to_string(account.id)}
  end

  def resource_from_claims(claims) do
    resource =
      claims["sub"]
      |> Backoffices.get_account!()

    {:ok, resource}
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.Cache.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.Cache.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.Cache.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
