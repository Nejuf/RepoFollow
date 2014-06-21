class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :public_email, :string
    add_column :users, :email, :string

    add_index :users, :email
  end
end
