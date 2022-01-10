defmodule Elibrary.BookServiceTest do
  use Elibrary.DataCase

  alias Elibrary.BookService
  alias Elibrary.Book

  describe "books" do
    @valid_attrs %{"name" => "test case 1"}
    @update_attrs %{"name" => "test case 2"}
    @invalid_attrs %{"name" => nil, "discription" => nil, "label_id" => nil}
  end

  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(@valid_attrs)
      |> BookService.create_book()

    book
  end

  test "list_books/0 returns all book limit 20" do
    book = book_fixture()
    [hd | _] = BookService.list_books()

    assert hd.id == book.id
    assert hd.name == book.name
    assert hd.label_id == book.label_id
  end

  test "get_book!/1 returns the book with given id" do
    book = book_fixture()
    result = BookService.get_book!(book.id)

    assert result.id == book.id
    assert result.name == book.name
    assert result.label_id == book.label_id
  end

  test "create_book/1 with valid data creates a book" do
    assert {:ok, %Book{} = book} = BookService.create_book(@valid_attrs)

    assert book.name == "test case 1"
  end

  test "create_book/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = BookService.create_book(@invalid_attrs)
  end

  test "update_book/2 with valid data updates the book" do
    book = book_fixture()
    assert {:ok, %Book{} = book} = BookService.update_book(book, @update_attrs)
    assert book.name == "test case 2"
  end

  test "update_book/2 with invalid data returns error changeset" do
    book = book_fixture()
    assert {:error, %Ecto.Changeset{}} = BookService.update_book(book, @invalid_attrs)
    result = BookService.get_book!(book.id)

    assert book.id == result.id
    assert book.name == result.name
  end

  # test "delete_book/1 deletes the book" do
  #   book = book_fixture()
  #   assert {:ok, %Book{}} = BookService.delete_book(book)
  #   assert_raise Ecto.NoResultsError, fn -> BookService.get_book!(book.id) end
  # end

  test "change_book/1 returns a book changeset" do
    book = book_fixture()
    assert %Ecto.Changeset{} = BookService.change_book(book)
  end

  test "Count all books record" do
    _ = book_fixture()
    assert BookService.sum_records() == 1
  end
end
