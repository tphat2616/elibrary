defmodule Elibrary.BookService do
  @moduledoc """
  The Book context.
  """

  import Ecto.Query, warn: false
  alias Elibrary.Repo
  alias Elibrary.Book
  alias Elibrary.LabelService
  import Ecto.Query

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    query = "
      select b.id, b.name, b.description, b.label_id, l.name as label_name
      from books as b
      left join labels as l
      on b.label_id = l.id
      group by b.id, l.name
      order by 1 desc limit 20;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    Enum.map(result.rows, &map_data_to_struct(Book, &1))
  end

  defp map_data_to_struct(model, list) do
    [id, name, desc, label_id, label_name] = list
    struct(model, %{id: id, name: name, description: desc, label_id: label_id, label_name: label_name})
  end

  @doc """
  Gets a single Book.

  Raises `Ecto.NoResultsError` if the book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id) do
    # Repo.get!(Book, id)
    query = "select b.id, b.name, b.description, b.label_id, l.name as label_name
     from books as b
     left join labels as l
     on b.label_id = l.id
     where b.id = $1
     group by 1, 2, 5;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [elem(Integer.parse(id), 0)])
    [hd | _] = Enum.map(result.rows, &map_data_to_struct(Book, &1))
    hd

  end

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    attrs = map_label_name_to_label_id(attrs)
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    attrs = map_label_name_to_label_id(attrs)
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Map label name to label id
  """

  def map_label_name_to_label_id(attrs) do
    label_id =
      if attrs["label_name"] != nil do
        if LabelService.get_label_by_name(attrs["label_name"]) != [] do
          [hd | _] = LabelService.get_label_by_name(attrs["label_name"])
          hd.id
        else
          nil
        end
      else
        nil
    end
    Map.put(attrs, "label_id", label_id) |> IO.inspect(label: "--------------------")
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = babel) do
    Repo.delete(babel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  @doc """
  Count all records
  """

  def sum_records() do
    query = "
    select count(*) from books;
    "
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    [hd | _] = result.rows
    [hd | _] = hd
    hd
  end
end
