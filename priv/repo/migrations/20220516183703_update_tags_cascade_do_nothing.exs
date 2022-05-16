defmodule Blog.Repo.Migrations.UpdateTagsCascadeDoNothing do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE posts_tags DROP CONSTRAINT posts_tags_post_id_fkey"

    alter table(:posts_tags) do
      modify :post_id, references(:posts, on_delete: :delete_all)
    end
  end

  def down do
    execute "ALTER TABLE posts_tags DROP CONSTRAINT posts_tags_post_id_fkey"

    alter table(:posts_tags) do
      modify :post_id, references(:posts)
    end
  end
end
