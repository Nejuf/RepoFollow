# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140624192227) do

  create_table "branches", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "repo_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "branches", ["repo_id"], :name => "index_branches_on_repo_id"

  create_table "follow_branches", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "branch_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "follow_branches", ["branch_id"], :name => "index_follow_branches_on_branch_id"
  add_index "follow_branches", ["user_id", "branch_id"], :name => "index_follow_branches_on_user_id_and_branch_id", :unique => true
  add_index "follow_branches", ["user_id"], :name => "index_follow_branches_on_user_id"

  create_table "follow_repos", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "repo_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "follow_repos", ["repo_id"], :name => "index_follow_repos_on_repo_id"
  add_index "follow_repos", ["user_id", "repo_id"], :name => "index_follow_repos_on_user_id_and_repo_id", :unique => true
  add_index "follow_repos", ["user_id"], :name => "index_follow_repos_on_user_id"

  create_table "repos", :force => true do |t|
    t.string   "github_uid", :null => false
    t.string   "name"
    t.string   "full_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "repos", ["github_uid"], :name => "index_repos_on_github_uid", :unique => true

  create_table "users", :force => true do |t|
    t.string   "github_uid",   :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "nickname"
    t.string   "public_email"
    t.string   "email"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["github_uid"], :name => "index_users_on_github_uid", :unique => true

end
