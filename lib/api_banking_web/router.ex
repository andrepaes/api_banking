defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_account_auth do
    plug ApiBanking.Auth.AccountPipeline
  end

  pipeline :api_backoffice_auth do
    plug ApiBanking.Auth.BackofficePipeline
  end

  scope "/api/v1", ApiBankingWeb do
    pipe_through :api

    post "/accounts/sign-up", AccountRegistrationController, :register
    post "/accounts/sign-in", AccountController, :sign_in
  end

  scope "/api/v1/accounts", ApiBankingWeb do
    pipe_through [:api, :api_account_auth]

    post "/withdraw", AccountController, :withdraw
    post "/transfer", AccountController, :transfer
    post "/sign-out", AccountController, :sign_out
  end

  scope "/api/v1/backoffices", ApiBankingWeb do
    pipe_through [:api]

    post "/sign-up", Backoffices.AccountController, :create
    post "/sign-in", Backoffices.AccountController, :sign_in
  end

  scope "/api/v1/backoffices", ApiBankingWeb do
    pipe_through [:api_backoffice_auth]


  end
end
