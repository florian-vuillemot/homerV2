defmodule HomerWeb.Router do
  use HomerWeb, :router

  def logged_in_action(conn, _params) do
    Guardian.Plug.current_resource(conn)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render("error.json", %{message: "Authentication required"})
  end

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

  pipeline :auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", HomerWeb do
    pipe_through :api # Use the default browser stack

    #get "/", PageController, :index
    #resources "/users", UserController
  end

  scope "/accounts", HomerWeb.Accounts, as: :accounts do
    pipe_through :api

    post "/login", UserAuth, :login
    get "/logout", UserAuth, :logout
    post "/create", UserController, :create

    pipe_through :auth
    post "/make_admin", UserController, :make_admin
    resources "/users", UserController, except: [:create]
  end

  scope "/monetizations", HomerWeb.Monetizations, as: :monetizations do
    pipe_through :api
    pipe_through :auth

    resources "/fundings", FundingController
  end

  scope "/builders", HomerWeb.Builders, as: :builders do
    pipe_through :api
    pipe_through :auth

    resources "/projects", ProjectController
  end

  scope "/invests", HomerWeb.Invests, as: :invests do
    pipe_through :api
    pipe_through :auth

    resources "/investors", InvestorController, except: [:edit, :update, :delete]
  end

  scope "/step_templates", HomerWeb.StepTemplates, as: :step_templates do
    pipe_through :api
    pipe_through :auth

    resources "/step_templates", StepTemplateController
  end

  scope "/steps", HomerWeb.Steps, as: :steps do
    pipe_through :api
    pipe_through :auth

    resources "/steps", StepController, except: [:create]
  end

  scope "/steps_validation", HomerWeb.StepsValidation, as: :steps_validation do
    pipe_through :api
    pipe_through :auth

    resources "/steps_validation", StepValidationController, except: [:edit, :update, :delete]
  end

  scope "/invests_allows", HomerWeb.InvestsAllows, as: :invests_allows do
    pipe_through :api
    pipe_through :auth

    resources "/invests_allows", InvestAllowController
  end

  scope "/funders", HomerWeb.Funders, as: :funders do
    pipe_through :api
    pipe_through :auth

    resources "/funders", FunderController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomerWeb do
  #   pipe_through :api
  # end
end
