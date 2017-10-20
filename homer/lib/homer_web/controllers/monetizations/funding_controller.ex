defmodule HomerWeb.Monetizations.FundingController do
  use HomerWeb, :controller

  alias Homer.Monetizations
  alias Homer.Monetizations.Funding
  alias HomerWeb.Utilities.GetId
  alias Homer.Accounts

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    fundings = Monetizations.list_fundings()
    render(conn, "index.json", fundings: fundings)
  end

  def create(conn, %{"funding" => funding_params}) do
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        with {:ok, %Funding{} = funding} <- Monetizations.create_funding(funding_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", monetizations_funding_path(conn, :show, funding))
          |> render("show.json", funding: funding)
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def show(conn, %{"id" => id}) do
    funding = Monetizations.get_funding!(id)
    render(conn, "show.json", funding: funding)
  end

  def update(conn, %{"id" => id, "funding" => funding_params}) do
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        funding = Monetizations.get_funding!(id)

        with {:ok, %Funding{} = funding} <- Monetizations.update_funding(funding, funding_params) do
          render(conn, "show.json", funding: funding)
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        funding = Monetizations.get_funding!(id)
        with {:ok, %Funding{}} <- Monetizations.delete_funding(funding) do
          send_resp(conn, :no_content, "")
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end
end
