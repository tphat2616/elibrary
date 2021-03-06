defmodule Elibrary.LabelService do
  @moduledoc """
  The Label context.
  """

  import Ecto.Query, warn: false
  alias Elibrary.Repo
  alias Elibrary.Label

  @doc """
  Returns the list of labels.

  ## Examples

      iex> list_labels()
      [%Label{}, ...]

  """
  def list_labels do
    Repo.all(Label)
  end

  @doc """
  Gets a single Label.

  Raises `Ecto.NoResultsError` if the Label does not exist.

  ## Examples

      iex> get_label!(123)
      %Label{}

      iex> get_label!(456)
      ** (Ecto.NoResultsError)

  """
  def get_label!(id), do: Repo.get!(Label, id)

  @doc """
  Creates a label.

  ## Examples

      iex> create_label(%{field: value})
      {:ok, %Label{}}

      iex> create_label(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_label(attrs \\ %{}) do
    %Label{}
    |> Label.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a label.

  ## Examples

      iex> update_label(label, %{field: new_value})
      {:ok, %Label{}}

      iex> update_label(label, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_label(%Label{} = label, attrs) do
    label
    |> Label.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a label.

  ## Examples

      iex> delete_label(label)
      {:ok, %Label{}}

      iex> delete_label(label)
      {:error, %Ecto.Changeset{}}

  """
  def delete_label(%Label{} = label) do
    Repo.delete(label)
  end

  def get_label_by_name(name) do
    query = "select * from labels where name = $1"
    result = Ecto.Adapters.SQL.query!(Repo, query, [name])
    Enum.map(result.rows, &map_data_to_struct_after_get_label_by_name(Label, &1))
  end

  defp map_data_to_struct_after_get_label_by_name(model, list) do
    [id, name, desc] = list
    struct(model, %{id: id, name: name, description: desc})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking label changes.

  ## Examples

      iex> change_label(label)
      %Ecto.Changeset{data: %label{}}

  """
  def change_label(%Label{} = label, attrs \\ %{}) do
    Label.changeset(label, attrs)
  end

  @doc """
  Search a label by a book, a song or a combo.
  """

  def search_label(key_query) do
    query = "
    (select l.id, l.name, l.description, word_similarity(b.name, $1) as acc, b.name as result
        from books as b
        join labels as l
        on b.label_id = l.id
        where b.name like '%' || $1 || '%'
        order by word_similarity($1, b.name) desc
        ) union
    (select l.id, l.name, l.description, word_similarity(s.name, $1) as acc, s.name as result
        from songs as s
        join labels as l
        on s.label_id = l.id
        where s.name like '%' || $1 || '%'
        order by word_similarity($1, s.name) desc
        ) union
    (select l.id, l.name, l.description, word_similarity(c.name, $1) as acc, c.name as result
        from combo as c
        join labels as l
        on c.label_id = l.id
        where c.name like '%' || $1 || '%'
        order by word_similarity($1, c.name) desc
        )
    order by acc desc
    limit 1;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [key_query])
    Enum.map(result.rows, &map_data_to_struct_after_search(Label, &1))
  end

  defp map_data_to_struct_after_search(model, list) do
    [id, name, desc, _, _] = list |> IO.inspect(label: "result---------")
    struct(model, %{id: id, name: name, description: desc})
  end

  def list_top_10_label_used_most() do
    query = "
      select id, name, description, sum(tag_count) as sum from
      (
          (select l.id, l.name, l.description, count(*) as tag_count
              from labels as l
              join books as b
              on l.id = b.label_id
              group by l.id
              order by tag_count
          ) union all
          (select l.id, l.name, l.description, count(*) as tag_count
              from labels as l
              join songs as s
              on l.id = s.label_id
              group by l.id
              order by tag_count
          ) union all
          (select l.id, l.name, l.description, count(*) as tag_count
              from labels as l
              join combo as c
              on l.id = c.label_id
              group by l.id
              order by tag_count
          )
      ) as sub
      group by 1, 2, 3
      order by sum desc
      limit 10;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    Enum.map(result.rows, &map_data_to_struct_from_top_10(Label, &1))
  end

  defp map_data_to_struct_from_top_10(model, list) do
    [id, name, desc, sum] = list
    struct(model, %{id: id, name: name, description: desc, sum: sum})
  end

  @doc """
    Count all records
  """

  def sum_records() do
    query = "
    select count(*) from labels;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    [hd | _] = result.rows
    [hd | _] = hd
    hd
  end
end
