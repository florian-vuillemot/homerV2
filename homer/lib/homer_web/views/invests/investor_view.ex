defmodule HomerWeb.Invests.InvestorView do
  use HomerWeb, :view
  alias HomerWeb.Invests.InvestorView

  def render("index.json", %{investors: investors}) do
    %{investors: render_many(investors, InvestorView, "investor.json")}
  end

  def render("show.json", %{investor: investor}) do
    %{investor: render_one(investor, InvestorView, "investor.json")}
  end

  def render("investor.json", %{investor: investor}) do
    investor = investor
             |> Homer.ViewsConverter.get_id(:steps_validation)

    %{id: investor.id,
      comment: investor.comment,
      steps_validation: investor.steps_validation,
      project: investor.project_id,
      user: investor.user_id,
      invest_allow: investor.invest_allow_id}
  end
end
