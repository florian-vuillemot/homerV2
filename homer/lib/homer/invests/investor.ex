defmodule Homer.Invests.Investor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Invests.Investor
  alias Homer.Accounts.User

  alias Homer.StepsValidation.StepValidation

  schema "investors" do
    field :comment, :string
    field :funding, :integer
    field :project_id, :id
    #field :user_id, :id
    belongs_to :user, User

    has_many :steps_validation, StepValidation

    timestamps()
  end

  @doc false
  def changeset(%Investor{} = investor, attrs) do
    investor
    |> cast(attrs, [:funding, :comment])
    |> validate_required([:funding, :comment])
  end
end
