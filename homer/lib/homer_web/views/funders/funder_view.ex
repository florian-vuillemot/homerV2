defmodule HomerWeb.Funders.FunderView do
  use HomerWeb, :view
  alias HomerWeb.Funders.FunderView

  def render("index.json", %{funders: funders}) do
    %{data: render_many(funders, FunderView, "funder.json")}
  end

  def render("show.json", %{funder: funder}) do
    %{data: render_one(funder, FunderView, "funder.json")}
  end

  def render("funder.json", %{funder: funder}) do
    %{id: funder.id,
      status: funder.status}
  end
end
