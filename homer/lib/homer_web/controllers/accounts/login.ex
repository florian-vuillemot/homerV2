defmodule HomerWeb.Accounts.UserAuth do
  use HomerWeb, :controller

  def login(conn, _params) do
    email = "email" #Map.get(user, "email")
    password = "pass" #Map.get(user, "password")
    Homer.Accounts.create_user(%{email: email, password: password})


    case Homer.Accounts.find_and_confirm_password(email, password) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)

        case Guardian.Plug.claims(new_conn) do
          {:ok, claims} ->
            exp = Map.get(claims, "exp")

            new_conn
            |> put_status(200)
            |> put_resp_header("authorization", "Bearer #{jwt}")
            |> put_resp_header("x-expires", "#{exp}")
            |> render("show.json", %{user: user, jwt: jwt, exp: exp})
          _ ->
            render_error(conn)
        end
      {:error, :unauthorized} ->
        render_error(conn)
    end
  end

  def logout(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        Guardian.revoke!(jwt, claims)
        render "logout.json"
      _ ->
        render_error(conn)
    end
  end


  ##############################################################################################
  ##############################################################################################
  ##############################################################################################
  ##############################################################################################
  ##############################################################################################

  defp render_error(conn) do
    conn
    |> put_status(401)
    |> render("error.json", %{message: "Could not login"})
  end
end