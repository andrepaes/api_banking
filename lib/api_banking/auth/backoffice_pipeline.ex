defmodule ApiBanking.Auth.BackofficePipeline do
  @moduledoc """
    Backoffice account authentication pipeline
  """

  use Guardian.Plug.Pipeline,
      otp_app: :api_banking,
      error_handler: ApiBanking.Auth.ErrorHandler,
      module: ApiBanking.Auth.GuardianBackoffice

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
