defmodule HomerWeb.Invests.InvestorView do
  use HomerWeb, :view
  alias HomerWeb.Invests.InvestorView

  def render("index.json", %{investors: investors}) do
    %{data: render_many(investors, InvestorView, "investor.json")}
  end

  def render("show.json", %{investor: investor}) do
    %{data: render_one(investor, InvestorView, "investor.json")}
  end

  def render("investor.json", %{investor: investor}) do
    %{id: investor.id,
      comment: investor.comment,
      steps_validation: investor.steps_validation}
  end
end
