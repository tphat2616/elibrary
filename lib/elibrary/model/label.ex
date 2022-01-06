defmodule Elibrary.Label do
  use Ecto.Schema
  import Ecto.Changeset

  @optional_key [
    :description
  ]

  @required_key [
    :name
  ]

  schema "labels" do
    field :name, :string
    field :description, :string

    has_one :song, Elibrary.Song, on_delete: :delete_all
    has_one :book, Elibrary.Book, on_delete: :delete_all
  end

  @doc false
  def changeset(%Elibrary.Label{} = tweet, params \\ %{}) do
    tweet
    |> cast(params, @optional_key ++ @required_key)
    |> validate_required(@required_key)
    |> check_body_size()
    |> unique_constraint(:name)
  end

  defp check_body_size(changeset) do
    changeset
    |> validate_length(:name, mix: 1, max: 100)
    |> validate_length(:description, mix: 0, max: 200)
  end
end
