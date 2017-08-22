defmodule HomerWeb.Monetization.FundingController do
  use HomerWeb, :controller

  alias Homer.Monetization
  alias Homer.Monetization.Funding

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    fundings = Monetization.list_fundings()
    render(conn, "index.json", fundings: fundings)
  end

  def create(conn, %{"funding" => funding_params}) do
    with {:ok, %Funding{} = funding} <- Monetization.create_funding(funding_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", monetization_funding_path(conn, :show, funding))
      |> render("show.json", funding: funding)
    end
  end

  def show(conn, %{"id" => id}) do
    funding = Monetization.get_funding!(id)
    render(conn, "show.json", funding: funding)
  end

  def update(conn, %{"id" => id, "funding" => funding_params}) do
    funding = Monetization.get_funding!(id)

    with {:ok, %Funding{} = funding} <- Monetization.update_funding(funding, funding_params) do
      render(conn, "show.json", funding: funding)
    end
  end

  def delete(conn, %{"id" => id}) do
    funding = Monetization.get_funding!(id)
    with {:ok, %Funding{}} <- Monetization.delete_funding(funding) do
      send_resp(conn, :no_content, "")
    end
  end
end
