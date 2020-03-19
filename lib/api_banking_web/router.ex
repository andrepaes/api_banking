defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ApiBankingWeb do
    pipe_through :api
  end
end
