defmodule HomerWeb.Accounts.UserAuthView do
  use HomerWeb, :view
  alias HomerWeb.Accounts.UserAuthView

  def render("show.json", user) do
    %{user: render_one(user, UserAuthView, "user.json")}
  end

  def render("user.json", user) do
  %{
    id: user.user_auth.user.id,
    email: user.user_auth.user.email
  }
  end

  def render("error.json", %{message: message}) do
    %{
      message: message
    }
  end
end
