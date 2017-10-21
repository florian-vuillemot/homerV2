defmodule HomerWeb.Accounts.UserAuth do
  use HomerWeb, :controller

  action_fallback HomerWeb.FallbackController

  def login(conn, params) do
    email = HomerWeb.Utilities.Convertor.get_correct_key(params, :email, "")
    password = HomerWeb.Utilities.Convertor.get_correct_key(params, :password, "")

    Homer.Accounts.create_user(%{email: email, password: password})

    case Homer.Accounts.find_and_confirm_password(email, password) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)

        case Guardian.Plug.claims(new_conn) do
          {:ok, claims} ->
            exp = HomerWeb.Utilities.Convertor.get_correct_key(claims, :exp, "")

            new_conn
            |> put_status(200)
            |> Plug.Conn.put_req_header("accept", "application/json")
            |> put_resp_header("authorization", "Bearer #{jwt}")
            |> put_resp_header("x-expires", "#{exp}")
            |> put_view(HomerWeb.Accounts.UserAuthView)
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
    |> put_view(HomerWeb.Accounts.UserAuthView)
    |> render("error.json", %{message: "Could not login"})
  end
end