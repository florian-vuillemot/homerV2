defmodule Homer.Invests.Investor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Invests.Investor
  alias Homer.Accounts.User

  alias Homer.StepsValidation.StepValidation
  alias Homer.Builders.Project
  alias Homer.InvestsAllows.InvestAllow

  schema "investors" do
    field :comment, :string

    #field :project_id, :id
    #field :user_id, :id
    belongs_to :project, Project
    belongs_to :user, User
    belongs_to :invest_allow, InvestAllow

    has_many :steps_validation, StepValidation

    timestamps()
  end

  @doc false
  def changeset(%Investor{} = investor, attrs) do
    investor
    |> cast(attrs, [:comment, :project_id, :user_id, :invest_allow_id])
    |> validate_required([:comment, :project_id, :user_id, :invest_allow_id])
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:invest_allow_id)
  end
end
