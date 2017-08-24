defmodule HomerWeb.Funders.FunderController do
  use HomerWeb, :controller

  alias Homer.Funders
  alias Homer.Funders.Funder

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    funders = Funders.list_funders()
    render(conn, "index.json", funders: funders)
  end

  def create(conn, %{"funder" => funder_params}) do
    with {:ok, %Funder{} = funder} <- Funders.create_funder(funder_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", funders_funder_path(conn, :show, funder))
      |> render("show.json", funder: funder)
    end
  end

  def show(conn, %{"id" => id}) do
    funder = Funders.get_funder!(id)
    render(conn, "show.json", funder: funder)
  end

  def update(conn, %{"id" => id, "funder" => funder_params}) do
    funder = Funders.get_funder!(id)

    with {:ok, %Funder{} = funder} <- Funders.update_funder(funder, funder_params) do
      render(conn, "show.json", funder: funder)
    end
  end

  def delete(conn, %{"id" => id}) do
    funder = Funders.get_funder!(id)
    with {:ok, %Funder{}} <- Funders.delete_funder(funder) do
      send_resp(conn, :no_content, "")
    end
  end
end
