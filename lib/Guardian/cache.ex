defmodule Guardian.Cache do
  @moduledoc """
    This module is used to provide a Cache plugin to guardian auth lib
  """

  alias ConCache
  @cache_id :guardian_ets

  @doc """
  After the JWT is generated, stores the various fields of it in the Cache for
  tracking. If the token type does not match the configured types to be stored,
  the claims are passed through.
  """
  def after_encode_and_sign(resource, type, claims, jwt) do
    case store_token(type, claims, jwt) do
      {:error, _} -> {:error, :token_storage_failure}
      _ -> {:ok, {resource, type, claims, jwt}}
    end
  end

  @doc """
  When a token is verified, check to make sure that it is present in the Cache.
  If the token is found, the verification continues, if not an error is
  returned.
  If the type of the token does not match the configured token storage types,
  the claims are passed through.
  """
  def on_verify(claims, jwt) do
    case find_token(claims) do
      [] -> {:error, :token_not_found}
      _ -> {:ok, {claims, jwt}}
    end
  end

  @doc """
  When revoking a token, removes from the cache so the
  token may no longer be used.
  """
  def on_revoke(claims, jwt) do
    claims
    |> find_by_claims()
    |> destroy_token(claims, jwt)
  end

  defp store_token(type, claims, jwt) do
    if storable_type?(type) do
      key = {jwt, Map.get(claims, "jti"), Map.get(claims, "aud")}
      ConCache.put(@cache_id, key, claims)
    else
      :ignore
    end
  end

  defp find_token(%{"typ" => type} = claims) do
    if storable_type?(type) do
      find_by_claims(claims)
    else
      :ignore
    end
  end

  def find_by_claims(claims) do
    jti = Map.get(claims, "jti")
    aud = Map.get(claims, "aud")
    key = {:_, jti, aud}

    @cache_id
    |> ConCache.ets
    |> :ets.match_object({key, :_})
  end

  def destroy_token(nil, claims, jwt), do: {:ok, {claims, jwt}}

  def destroy_token(_model, claims, jwt) do
    jti = Map.get(claims, "jti")
    aud = Map.get(claims, "aud")
    key = {jwt, jti, aud}

    case ConCache.delete(@cache_id, key) do
      :ok -> {:ok, {claims, jwt}}
      _ -> {:error, :could_not_revoke_token}
    end
  end

  defp token_types do
    :guardian
    |> Application.fetch_env!(Guardian.Cache)
    |> Keyword.get(:token_types, [])
  end

  defp storable_type?(type), do: storable_type?(type, token_types())

  # Store all types by default
  defp storable_type?(_, []), do: true
  defp storable_type?(type, types), do: type in types
end