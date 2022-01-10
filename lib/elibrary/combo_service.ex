defmodule Elibrary.ComboService do
  @moduledoc """
  The Combo context.
  """

  import Ecto.Query, warn: false
  alias Elibrary.Repo
  alias Elibrary.Combo
  alias Elibrary.Book
  alias Elibrary.Song
  alias Elibrary.BookService
  alias Elibrary.SongService
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
  def get_combo!(id) do
    query = "select c.id, c.name,
              l.id as label_id, l.name as label_name,
              b.id as book_id, b.name as book_name,
              s.id as song_id, s.name as song_name
     from combo as c
     left join labels as l
     on c.label_id = l.id
     left join books as b
     on c.book_id = b.id
     left join songs as s
     on c.song_id = s.id
     where c.id = $1
     group by 1, 2, 3, 5, 7;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [id])
    [hd | _] = Enum.map(result.rows, &map_data_with_book_song_and_label(Combo, &1))
    hd
  end

  defp map_data_with_book_song_and_label(model, list) do
    [id, name, label_id, label_name, book_id, book_name, song_id, song_name] = list

    struct(model, %{
      id: id,
      name: name,
      label_id: label_id,
      label_name: label_name,
      book_id: book_id,
      book_name: book_name,
      song_id: song_id,
      song_name: song_name
    })
  end

  @doc """
  Creates a combo.

  ## Examples

      iex> create_combo(%{field: value})
      {:ok, %Combo{}}

      iex> create_combo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_combo(attrs \\ %{}) do
    attrs =
      attrs
      |> BookService.map_label_name_to_label_id()
      |> map_book_id_by_book_name()
      |> map_song_id_by_song_name()
      |> map_book_and_song_into_combo()

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
    attrs =
      attrs
      |> BookService.map_label_name_to_label_id()
      |> map_book_id_by_book_name()
      |> map_song_id_by_song_name()
      |> map_book_and_song_into_combo()

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

  @doc """
    Count all records
  """

  def sum_records() do
    query = "
    select count(*) from combo;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    [hd | _] = result.rows
    [hd | _] = hd
    hd
  end

  @doc """
   Add book id from book name
  """
  defp map_book_id_by_book_name(attrs) do
    book_id =
      if attrs["book_name"] != nil do
        if BookService.get_book_by_name(attrs["book_name"]) != [] do
          [hd | _] = BookService.get_book_by_name(attrs["book_name"])
          hd.id
        else
          nil
        end
      else
        nil
      end

    Map.put(attrs, "book_id", book_id)
  end

  @doc """
   Add song id from song name
  """
  defp map_song_id_by_song_name(attrs) do
    song_id =
      if attrs["song_name"] != nil do
        if SongService.get_song_by_name(attrs["song_name"]) != [] do
          [hd | _] = SongService.get_song_by_name(attrs["song_name"])
          hd.id
        else
          nil
        end
      else
        nil
      end

    Map.put(attrs, "song_id", song_id)
  end

  @doc """
   Add song and song into combo
  """
  defp map_book_and_song_into_combo(attrs) do
    name = "#{attrs["book_name"]} and #{attrs["song_name"]}"
    Map.put(attrs, "name", name)
  end
end
