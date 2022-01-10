defmodule Elibrary.SongServiceTest do
  use Elibrary.DataCase

  alias Elibrary.SongService
  alias Elibrary.Song

  describe "songs" do
    @valid_attrs %{"name" => "test case 1"}
    @update_attrs %{"name" => "test case 2"}
    @invalid_attrs %{"name" => nil, "discription" => nil, "label_id" => nil}
  end

  def song_fixture(attrs \\ %{}) do
    {:ok, song} =
      attrs
      |> Enum.into(@valid_attrs)
      |> SongService.create_song()

    song
  end

  test "list_songs/0 returns all song limit 20" do
    song = song_fixture()
    [hd | _] = SongService.list_songs()

    assert hd.id == song.id
    assert hd.name == song.name
    assert hd.label_id == song.label_id
  end

  test "get_song!/1 returns the song with given id" do
    song = song_fixture()
    result = SongService.get_song!(song.id)

    assert result.id == song.id
    assert result.name == song.name
    assert result.label_id == song.label_id
  end

  test "create_song/1 with valid data creates a song" do
    assert {:ok, %Song{} = song} = SongService.create_song(@valid_attrs)

    assert song.name == "test case 1"
  end

  test "create_song/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = SongService.create_song(@invalid_attrs)
  end

  test "update_song/2 with valid data updates the song" do
    song = song_fixture()
    assert {:ok, %Song{} = song} = SongService.update_song(song, @update_attrs)
    assert song.name == "test case 2"
  end

  test "update_song/2 with invalid data returns error changeset" do
    song = song_fixture()
    assert {:error, %Ecto.Changeset{}} = SongService.update_song(song, @invalid_attrs)
    result = SongService.get_song!(song.id)

    assert song.id == result.id
    assert song.name == result.name
  end

  # test "delete_song/1 deletes the song" do
  #   song = song_fixture()
  #   assert {:ok, %Song{}} = SongService.delete_song(song)
  #   assert_raise Ecto.NoResultsError, fn -> SongService.get_song!(song.id) end
  # end

  test "change_song/1 returns a song changeset" do
    song = song_fixture()
    assert %Ecto.Changeset{} = SongService.change_song(song)
  end

  test "Count all songs record" do
    _ = song_fixture()
    assert SongService.sum_records() == 1
  end
end
