defmodule ApiBanking.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :api_banking,
      error_handler: ApiBanking.Auth.ErrorHandler,
      module: ApiBanking.Auth.GuardianAccount

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  plug Guardian.Plug.LoadResource, allow_blank: true
end