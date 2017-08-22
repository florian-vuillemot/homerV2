defmodule HomerWeb.Router do
  use HomerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomerWeb do
    pipe_through :api # Use the default browser stack

    #get "/", PageController, :index
    #resources "/users", UserController
  end

  scope "/accounts", HomerWeb.Accounts, as: :accounts do
    pipe_through :api

    resources "/users", UserController
  end

  scope "/monetization", HomerWeb.Monetization, as: :monetization do
    pipe_through :api

    resources "/fundings", FundingController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomerWeb do
  #   pipe_through :api
  # end
end
