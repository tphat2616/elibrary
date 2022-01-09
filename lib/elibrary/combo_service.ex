defmodule Elibrary.ComboService do
  @moduledoc """
  The Combo context.
  """

  import Ecto.Query, warn: false
  alias Elibrary.Repo
  alias Elibrary.Combo
  import Ecto.Query

  @doc """
  Returns the list of combo.

  ## Examples

      iex> list_combo()
      [%Combo{}, ...]

  """
  def list_combo do
    query = "
      select c.id, c.name, c.label_id, l.name as label_name
      from combo as c
      left join labels as l
      on c.label_id = l.id
      group by c.id, c.name, c.label_id, l.name
      order by 1 desc limit 20;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    Enum.map(result.rows, &map_data_to_struct(Combo, &1))
  end

  defp map_data_to_struct(model, list) do
    [id, name, label_id, label_name] = list
    struct(model, %{id: id, name: name, label_id: label_id, label_name: label_name})
  end

  @doc """
  Gets a single combo.

  Raises `Ecto.NoResultsError` if the combo does not exist.

  ## Examples

      iex> get_combo!(123)
      %Combo{}

      iex> get_combo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_combo!(id), do: Repo.get!(Combo, id)

  @doc """
  Creates a combo.

  ## Examples

      iex> create_combo(%{field: value})
      {:ok, %Combo{}}

      iex> create_combo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_combo(attrs \\ %{}) do
    %Combo{}
    |> Combo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a combo.

  ## Examples

      iex> update_combo(combo, %{field: new_value})
      {:ok, %Combo{}}

      iex> update_combo(combo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_combo(%Combo{} = combo, attrs) do
    combo
    |> Combo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a combo.

  ## Examples

      iex> delete_combo(combo)
      {:ok, %Combo{}}

      iex> delete_combo(combo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_combo(%Combo{} = babel) do
    Repo.delete(babel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking combo changes.

  ## Examples

      iex> change_combo(combo)
      %Ecto.Changeset{data: %Combo{}}

  """
  def change_combo(%Combo{} = combo, attrs \\ %{}) do
    Combo.changeset(combo, attrs)
  end
end
