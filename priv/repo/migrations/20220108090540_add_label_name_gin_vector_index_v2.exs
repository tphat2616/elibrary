defmodule Elibrary.Repo.Migrations.AddLabelNameGinVectorIndexV2 do
  use Ecto.Migration

  def change do
    execute "CREATE INDEX labels_name_gin_vector_index ON labels USING gin(to_tsvector('english', name));"
  end
end
