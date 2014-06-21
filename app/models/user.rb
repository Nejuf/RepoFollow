class User < ActiveRecord::Base
  attr_accessible :github_uid, :name, :nickname, :public_email, :email

  validates_presence_of :github_uid

  validates_uniqueness_of :github_uid

  has_many :follow_repos
  has_many :followed_repos, through: :follow_repos, class_name: 'Repo', source: :repo

  def display_name
    nickname || name
  end
end
