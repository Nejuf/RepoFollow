class User < ActiveRecord::Base
  attr_accessible :github_uid, :name, :nickname, :public_email, :email

  validates_presence_of :github_uid

  validates_uniqueness_of :github_uid
end
