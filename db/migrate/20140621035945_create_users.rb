class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :github_uid, null: false

      t.timestamps
    end

    add_index :users, [:github_uid], unique: true
  end
end
