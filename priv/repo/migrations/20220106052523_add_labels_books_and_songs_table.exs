defmodule Elibrary.Repo.Migrations.AddLabelsBooksAndSongsTable do
  use Ecto.Migration

  def change do

    create table "labels" do
      add :name, :string, [size: 100, null: false]
      add :description, :string, [size: 200]
    end

    create table "songs" do
      add :name, :string, [size: 100, null: false]
      add :description, :string, [size: 200]
      add :label_id, references(:labels)
    end

    create table "books" do
      add :name, :string, [size: 100, null: false]
      add :description, :string, [size: 200]
      add :label_id, references(:labels)
    end
  end
end
