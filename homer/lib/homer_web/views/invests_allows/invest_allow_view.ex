defmodule HomerWeb.InvestsAllows.InvestAllowView do
  use HomerWeb, :view
  alias HomerWeb.InvestsAllows.InvestAllowView

  def render("index.json", %{invests_allows: invests_allows}) do
    %{invest_allows: render_many(invests_allows, InvestAllowView, "invest_allow.json")}
  end

  def render("show.json", %{invest_allow: invest_allow}) do
    %{invest_allow: render_one(invest_allow, InvestAllowView, "invest_allow.json")}
  end

  def render("invest_allow.json", %{invest_allow: invest_allow}) do
    %{id: invest_allow.id,
      name: invest_allow.name,
      description: invest_allow.description,
      invest: invest_allow.invest}
  end
end
