defmodule HomerWeb.InvestsAllows.InvestAllowController do
  use HomerWeb, :controller

  alias Homer.InvestsAllows
  alias Homer.InvestsAllows.InvestAllow

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    invests_allows = InvestsAllows.list_invests_allows()
    render(conn, "index.json", invests_allows: invests_allows)
  end

  def create(conn, %{"invest_allow" => invest_allow_params}) do
    with {:ok, %InvestAllow{} = invest_allow} <- InvestsAllows.create_invest_allow(invest_allow_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", invests_allows_invest_allow_path(conn, :show, invest_allow))
      |> render("show.json", invest_allow: invest_allow)
    end
  end

  def show(conn, %{"id" => id}) do
    invest_allow = InvestsAllows.get_invest_allow!(id)
    render(conn, "show.json", invest_allow: invest_allow)
  end

  def update(conn, %{"id" => id, "invest_allow" => invest_allow_params}) do
    invest_allow = InvestsAllows.get_invest_allow!(id)

    with {:ok, %InvestAllow{} = invest_allow} <- InvestsAllows.update_invest_allow(invest_allow, invest_allow_params) do
      render(conn, "show.json", invest_allow: invest_allow)
    end
  end

  def delete(conn, %{"id" => id}) do
    invest_allow = InvestsAllows.get_invest_allow!(id)
    with {:ok, %InvestAllow{}} <- InvestsAllows.delete_invest_allow(invest_allow) do
      send_resp(conn, :no_content, "")
    end
  end
end
