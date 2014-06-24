class Repo < ActiveRecord::Base
  attr_accessible :full_name, :github_uid, :name

  validates_presence_of :github_uid

  validates_uniqueness_of :github_uid

  has_many :follow_repos
  has_many :followers, class_name: 'User', source: :user, through: :follow_repos

  has_many :branches
end
