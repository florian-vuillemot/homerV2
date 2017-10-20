defmodule HomerWeb.Accounts.UserController do
  use HomerWeb, :controller

  alias Homer.Accounts
  alias Homer.Accounts.User
  alias HomerWeb.Utilities.GetId
  alias Homer.Accounts

  action_fallback HomerWeb.FallbackController

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
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        user = Accounts.get_user!(id)
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def make_admin(conn, %{"id" => id}) do
    conn_id = HomerWeb.Utilities.GetId.get_id(conn)

    case Accounts.is_admin?(conn_id) do
      true ->
        Accounts.make_admin(id)
        send_resp(conn, :no_content, "")
      _ -> send_resp(conn, :not_found, "")
    end
  end
end
