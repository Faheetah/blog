defmodule Blog.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
    end

    create table(:posts_tags) do
      add(:post_id, references(:posts))
      add(:tag_id, references(:tags))
    end

    create unique_index(:tags, [:name])
  end
end
