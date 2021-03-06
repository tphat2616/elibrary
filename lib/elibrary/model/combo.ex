defmodule Elibrary.Combo do
  use Ecto.Schema
  import Ecto.Changeset

  @optional_key [
    :label_id
  ]

  @required_key [
    :name,
    :song_id,
    :book_id
  ]

  schema "combo" do
    field :name, :string
    field :label_name, :string, virtual: true
    field :song_name, :string, virtual: true
    field :book_name, :string, virtual: true

    belongs_to :song, Elibrary.Song
    belongs_to :book, Elibrary.Book
    belongs_to :label, Elibrary.Label
  end

  @doc false
  def changeset(%Elibrary.Combo{} = combo, params \\ %{}) do
    combo
    |> cast(params, @optional_key ++ @required_key)
    |> validate_required(@required_key)
    |> check_body_size()
    |> unique_constraint(:name)
    |> validate_format(:name, ~r/^[a-z0-9 ]*+$/, message: "Accepted unique lowcase!")
  end

  defp check_body_size(changeset) do
    changeset
    |> validate_length(:name, mix: 1, max: 100)
  end
end
