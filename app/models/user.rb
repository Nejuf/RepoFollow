class User < ActiveRecord::Base
  attr_accessible :github_uid

  validates_presence_of :github_uid

  validates_uniqueness_of :github_uid
end
