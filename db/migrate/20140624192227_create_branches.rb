class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name, null: false
      t.integer :repo_id, null: false

      t.timestamps
    end

    add_index :branches, :repo_id
  end
end
