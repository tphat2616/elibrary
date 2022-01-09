defmodule Elibrary.Repo.Migrations.AddBookSongComboNameGinVectorIndex do
  use Ecto.Migration

  def change do
    execute "CREATE INDEX boooks_name_gin_vector_index ON books USING gin(to_tsvector('english', name));"

    execute "CREATE INDEX songs_name_gin_vector_index ON songs USING gin(to_tsvector('english', name));"

    execute "CREATE INDEX combo_name_gin_vector_index ON combo USING gin(to_tsvector('english', name));"
  end
end
