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

  scope "/monetizations", HomerWeb.Monetizations, as: :monetizations do
    pipe_through :api

    resources "/fundings", FundingController
  end

  scope "/builders", HomerWeb.Builders, as: :builders do
    pipe_through :api

    resources "/projects", ProjectController
  end

  scope "/invests", HomerWeb.Invests, as: :invests do
    pipe_through :api

    resources "/investors", InvestorController
  end

  scope "/step_templates", HomerWeb.StepTemplates, as: :step_templates do
    pipe_through :api

    resources "/step_templates", StepTemplateController
  end

  scope "/steps", HomerWeb.Steps, as: :steps do
    pipe_through :api

    resources "/steps", StepController
  end

  scope "/steps_validation", HomerWeb.StepsValidation, as: :steps_validation do
    pipe_through :api

    resources "/steps_validation", StepValidationController
  end

  scope "/invests_allows", HomerWeb.InvestsAllows, as: :invests_allows do
    pipe_through :api

    resources "/invests_allows", InvestAllowController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomerWeb do
  #   pipe_through :api
  # end
end
