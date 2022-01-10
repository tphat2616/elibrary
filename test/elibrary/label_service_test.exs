defmodule Elibrary.LabelServiceTest do
  use Elibrary.DataCase

  alias Elibrary.LabelService
  alias Elibrary.Label

  describe "labels" do
    @valid_attrs %{"name" => "test case 1"}
    @update_attrs %{"name" => "test case 2"}
    @invalid_attrs %{"name" => nil, "discription" => nil}
  end

  def label_fixture(attrs \\ %{}) do
    {:ok, label} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LabelService.create_label()

    label
  end

  test "list_labels/0 returns all labels" do
    label = label_fixture()
    [hd | _] = LabelService.list_labels()

    assert hd.id == label.id
    assert hd.name == label.name
  end

  test "get_label!/1 returns the label with given id" do
    label = label_fixture()
    result = LabelService.get_label!(label.id)

    assert result.id == label.id
    assert result.name == label.name
  end

  test "create_label/1 with valid data creates a label" do
    assert {:ok, %Label{} = label} = LabelService.create_label(@valid_attrs)

    assert label.name == "test case 1"
  end

  test "create_label/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = LabelService.create_label(@invalid_attrs)
  end

  test "update_label/2 with valid data updates the label" do
    label = label_fixture()
    assert {:ok, %Label{} = label} = LabelService.update_label(label, @update_attrs)
    assert label.name == "test case 2"
  end

  test "update_label/2 with invalid data returns error changeset" do
    label = label_fixture()
    assert {:error, %Ecto.Changeset{}} = LabelService.update_label(label, @invalid_attrs)
    result = LabelService.get_label!(label.id)

    assert label.id == result.id
    assert label.name == result.name
  end

  # test "delete_label/1 deletes the label" do
  #   label = label_fixture()
  #   assert {:ok, %Label{}} = LabelService.delete_label(label)
  #   assert_raise Ecto.NoResultsError, fn -> LabelService.get_label!(label.id) end
  # end

  test "change_label/1 returns a label changeset" do
    label = label_fixture()
    assert %Ecto.Changeset{} = LabelService.change_label(label)
  end

  test "Count all labels record" do
    _ = label_fixture()
    assert LabelService.sum_records() == 1
  end
end
