defmodule Elibrary.Song do
  use Ecto.Schema
  import Ecto.Changeset

  @optional_key [
    :description,
    :label_id,
    :label_name
  ]

  @required_key [
    :name
  ]

  schema "songs" do
    field :name, :string
    field :description, :string
    field :label_name, :string

    belongs_to :label, Elibrary.Label
  end

  @doc false
  def changeset(%Elibrary.Song{} = song, params \\ %{}) do
    song
    |> cast(params, @optional_key ++ @required_key)
    |> validate_required(@required_key)
    |> check_body_size()
    |> unique_constraint(:name)
    |> validate_format(:name, ~r/^[a-z0-9 ]*+$/, message: "Accepted unique lowcase!")
  end

  defp check_body_size(changeset) do
    changeset
    |> validate_length(:name, mix: 1, max: 100)
    |> validate_length(:description, mix: 0, max: 200)
  end
end
