defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug ApiBanking.Auth.Pipeline
  end

  scope "/api/v1", ApiBankingWeb do
    pipe_through :api
    post "/accounts/sign-up", AccountRegistrationController, :register
    post "/accounts/sign-in", AccountController, :sign_in
  end

  scope "/api/v1/accounts", ApiBankingWeb do
    pipe_through [:api, :api_auth]
    post "/withdraw", AccountController, :withdraw
    post "/transfer", AccountController, :transfer
    post "/sign-out", AccountController, :sign_out
  end
end
