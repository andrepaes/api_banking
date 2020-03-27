defmodule ApiBanking.Auth.AccountPipeline do
  @moduledoc """
    Account authentication pipeline
  """

  use Guardian.Plug.Pipeline,
    otp_app: :api_banking,
    error_handler: ApiBanking.Auth.ErrorHandler,
    module: ApiBanking.Auth.GuardianAccount

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
