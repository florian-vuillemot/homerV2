defmodule HomerWeb.Invests.InvestorController do
  use HomerWeb, :controller

  alias Homer.Invests
  alias Homer.Invests.Investor

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    investors = Invests.list_investors()
    render(conn, "index.json", investors: investors)
  end

  def create(conn, %{"investor" => investor_params}) do
    with {:ok, %Investor{} = investor} <- Invests.create_investor(investor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", invests_investor_path(conn, :show, investor))
      |> render("show.json", investor: investor)
    end
  end

  def show(conn, %{"id" => id}) do
    investor = Invests.get_investor!(id)
    render(conn, "show.json", investor: investor)
  end

  def update(conn, %{"id" => id, "investor" => investor_params}) do
    investor = Invests.get_investor!(id)

    with {:ok, %Investor{} = investor} <- Invests.update_investor(investor, investor_params) do
      render(conn, "show.json", investor: investor)
    end
  end

  def delete(conn, %{"id" => id}) do
    investor = Invests.get_investor!(id)
    with {:ok, %Investor{}} <- Invests.delete_investor(investor) do
      send_resp(conn, :no_content, "")
    end
  end
end
