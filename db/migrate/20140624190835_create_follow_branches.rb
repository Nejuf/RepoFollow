class CreateFollowBranches < ActiveRecord::Migration
  def change
    create_table :follow_branches do |t|
      t.integer :user_id, null: false
      t.integer :branch_id, null: false

      t.timestamps
    end

    add_index :follow_branches, :user_id
    add_index :follow_branches, :branch_id
    add_index :follow_branches, [:user_id, :branch_id], unique: true
  end
end
