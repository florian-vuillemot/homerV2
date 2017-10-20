defmodule Homer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Accounts.User
  alias Homer.Invests.Investor

  alias Homer.Funders.Funder

  schema "users" do
    field :email, :string
    field :password, :string
    field :admin, :integer, default: 0

    has_many :investor_on, Investor
    has_many :funders, Funder

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  @doc false
  def make_admin(%User{} = user) do
    user
    |> cast(%{admin: 1}, [:admin])
    |> validate_required([:email, :password])
  end
end
