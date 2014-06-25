class CreateUnfollowBranches < ActiveRecord::Migration
  def change
    create_table :unfollow_branches do |t|
      t.integer :user_id, null: false
      t.integer :branch_id, null: false

      t.timestamps
    end

    add_index :unfollow_branches, :user_id
    add_index :unfollow_branches, :branch_id
    add_index :unfollow_branches, [:user_id, :branch_id], unique: true
  end
end
