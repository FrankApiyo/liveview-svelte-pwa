defmodule LiveViewSvelteOfflineDemo.Repo.Migrations.AddUserRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_role, :integer, default: 0, null: false
    end
  end
end
