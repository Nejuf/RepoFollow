class CreateFollowRepos < ActiveRecord::Migration
  def change
    create_table :follow_repos do |t|
      t.integer :user_id, null: false
      t.integer :repo_id, null: false

      t.timestamps
    end

    add_index :follow_repos, :user_id
    add_index :follow_repos, :repo_id
    add_index :follow_repos, [:user_id, :repo_id], unique: true
  end
end
