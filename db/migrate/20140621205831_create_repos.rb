class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :github_uid, null: false
      t.string :name
      t.string :full_name

      t.timestamps
    end

    add_index :repos, :github_uid, unique: true
  end
end
