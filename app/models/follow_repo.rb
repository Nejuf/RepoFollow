class FollowRepo < ActiveRecord::Base
  attr_accessible :repo_id, :user_id

  belongs_to :user
  belongs_to :repo

  validates_presence_of :user_id, :repo_id

  validates :user_id, uniqueness: {scope: :repo_id}
end
