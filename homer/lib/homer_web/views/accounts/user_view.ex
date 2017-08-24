defmodule HomerWeb.Accounts.UserView do
  use HomerWeb, :view
  alias HomerWeb.Accounts.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      investor_on: user.investor_on,
      funders: user.funders}
  end
end
