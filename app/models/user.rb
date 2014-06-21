class User < ActiveRecord::Base
  attr_accessible :github_uid, :name, :nickname, :public_email, :email

  validates_presence_of :github_uid

  validates_uniqueness_of :github_uid

  has_many :follow_repos
  has_many :repos, through: :follow_repos

  def display_name
    nickname || name
  end
end
