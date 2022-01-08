defmodule Elibrary.Repo.Migrations.AddFourTables do
  use Ecto.Migration

  def change do
    create table("labels") do
      add :name, :string, size: 100, null: false
      add :description, :string, size: 200
    end

    create table("songs") do
      add :name, :string, size: 100, null: false
      add :description, :string, size: 200
      add :label_id, references(:labels)
    end

    create table("books") do
      add :name, :string, size: 100, null: false
      add :description, :string, size: 200
      add :label_id, references(:labels)
    end

    create table("combo") do
      add :name, :string, size: 100, null: false
      add :song_id, references(:songs), primary_key: true
      add :book_id, references(:books), primary_key: true
      add :label_id, references(:labels)
    end

    create index(:labels, [:name], unique: true)
    create index(:songs, [:name], unique: true)
    create index(:books, [:name], unique: true)
    create index(:combo, [:name], unique: true)

    execute "CREATE EXTENSION pg_trgm;"
    execute "CREATE INDEX labels_name_gin_pg_trgm ON labels USING gin(name gin_trgm_ops);"
    execute "CREATE INDEX songs_name_gin_pg_trgm ON songs USING gin(name gin_trgm_ops);"
    execute "CREATE INDEX books_name_gin_pg_trgm ON books USING gin(name gin_trgm_ops);"
    execute "CREATE INDEX combo_name_gin_pg_trgm ON combo USING gin(name gin_trgm_ops);"
  end
end
