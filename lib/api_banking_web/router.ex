defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ApiBankingWeb do
    pipe_through :api
    post "/accounts/sign-up", AccountRegistrationController, :register
    scope "/accounts", AccountController do

    end
  end
end
