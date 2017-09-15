defmodule HomerWeb.Accounts.UserController do
  use HomerWeb, :controller

  alias Homer.Accounts
  alias Homer.Accounts.User

  action_fallback HomerWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def logged_in_action(conn, _params) do
    Guardian.Plug.current_resource(conn)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render("error.json", %{message: "Authentication required"})
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", accounts_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
