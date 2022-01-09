defmodule Elibrary.SongService do
  @moduledoc """
  The Song context.
  """

  import Ecto.Query, warn: false
  alias Elibrary.Repo
  alias Elibrary.Song
  alias Elibrary.BookService

  @doc """
  Returns the list of songs.

  ## Examples

      iex> list_songs()
      [%Song{}, ...]

  """
  def list_songs do
    query = "
      select s.id, s.name, s.description, s.label_id, l.name as label_name
      from songs as s
      left join labels as l
      on s.label_id = l.id
      group by s.id, l.name
      order by 1 desc limit 20;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    Enum.map(result.rows, &map_data_to_struct(Song, &1))
  end

  defp map_data_to_struct(model, list) do
    [id, name, desc, label_id, label_name] = list
    struct(model, %{id: id, name: name, description: desc, label_id: label_id, label_name: label_name})
  end

  @doc """
  Gets a single Song.

  Raises `Ecto.NoResultsError` if the song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id), do: Repo.get!(Song, id)

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(attrs \\ %{}) do
    attrs = BookService.map_label_name_to_label_id(attrs)
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    attrs = BookService.map_label_name_to_label_id(attrs)
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = babel) do
    Repo.delete(babel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{data: %Song{}}

  """
  def change_song(%Song{} = song, attrs \\ %{}) do
    Song.changeset(song, attrs)
  end
    @doc """
  Count all records
  """

  def sum_records() do
    query = "
    select count(*) from songs;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    [hd | _] = result.rows
    [hd | _] = hd
    hd
  end
end
