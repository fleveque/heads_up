defmodule HeadsUp.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  schema "incidents" do
    field :name, :string
    field :priority, :integer, default: 1
    field :status, Ecto.Enum, values: [:pending, :resolved, :canceled], default: :pending
    field :description, :string
    field :image_path, :string, default: "/images/placeholder.jpg"

    timestamps(type: :utc_datetime)

    belongs_to :category, HeadsUp.Categories.Category
    has_many :responses, HeadsUp.Responses.Response
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:name, :description, :priority, :status, :image_path, :category_id])
    |> validate_required([:name, :description, :priority, :status, :image_path, :category_id])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:description, min: 10, max: 500)
    |> validate_number(:priority, greater_than: 0, less_than: 3)
    |> assoc_constraint(:category)
  end
end
