defmodule Elibrary.ComboServiceTest do
  use Elibrary.DataCase

  alias Elibrary.ComboService
  alias Elibrary.BookService
  alias Elibrary.SongService
  alias Elibrary.LabelService
  alias Elibrary.Combo

  describe "combo" do
    @book_attrs %{"name" => "book1"}
    @song_attrs %{"name" => "song1"}
    @label_attrs %{"name" => "label1"}
    @updated_attrs %{"book_name" => "book1", "song_name" => "song1", "label_name" => "label1"}
    @invalid_attrs %{"name" => nil, "discription" => nil}
  end

  def combo_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(@book_attrs)
      |> BookService.create_book()

    {:ok, song} =
      attrs
      |> Enum.into(@song_attrs)
      |> SongService.create_song()

    {:ok, _} =
      attrs
      |> Enum.into(@label_attrs)
      |> LabelService.create_label()

    attrs =
      %{}
      |> Map.put("boook_id", book.id)
      |> Map.put("song_id", song.id)
      |> Map.put("book_name", book.name)
      |> Map.put("song_name", song.name)

    {:ok, combo} =
      attrs
      |> Enum.into(%{})
      |> ComboService.create_combo()

    combo
  end

  test "list_combo/0 returns all combo" do
    combo = combo_fixture()
    [hd | _] = ComboService.list_combo()

    assert hd.id == combo.id
    assert hd.name == combo.name
  end

  test "get_combo!/1 returns the combo with given id" do
    combo = combo_fixture()
    result = ComboService.get_combo!(combo.id)

    assert result.id == combo.id
    assert result.name == combo.name
  end

  test "create_combo/1 with valid data creates a combo" do
    {:ok, book} =
      %{}
      |> Enum.into(@book_attrs)
      |> BookService.create_book()

    {:ok, song} =
      %{}
      |> Enum.into(@song_attrs)
      |> SongService.create_song()

    attrs =
      %{}
      |> Map.put("boook_id", book.id)
      |> Map.put("song_id", song.id)
      |> Map.put("book_name", book.name)
      |> Map.put("song_name", song.name)

    assert {:ok, %Combo{} = combo} = ComboService.create_combo(attrs)

    assert combo.name == "book1 and song1"
  end

  test "create_combo/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = ComboService.create_combo(@invalid_attrs)
  end

  test "update_combo/2 with valid data updates the combo" do
    combo = combo_fixture()
    assert {:ok, %Combo{} = combo} = ComboService.update_combo(combo, @updated_attrs)
    assert combo.name == "book1 and song1"
  end

  test "update_combo/2 with invalid data returns error changeset" do
    combo = combo_fixture()
    assert {:error, %Ecto.Changeset{}} = ComboService.update_combo(combo, @invalid_attrs)
    result = ComboService.get_combo!(combo.id)

    assert combo.id == result.id
  end

  # test "delete_combo/1 deletes the combo" do
  #   combo = combo_fixture()
  #   assert {:ok, %Combo{}} = ComboService.delete_combo(combo)
  #   assert_raise Ecto.NoResultsError, fn -> ComboService.get_combo!(combo.id) end
  # end

  test "change_combo/1 returns a combo changeset" do
    combo = combo_fixture()
    assert %Ecto.Changeset{} = ComboService.change_combo(combo)
  end

  test "Count all combo record" do
    _ = combo_fixture()
    assert ComboService.sum_records() == 1
  end
end
