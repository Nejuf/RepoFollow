class Branch < ActiveRecord::Base
  attr_accessible :name, :repo_id

  validates_presence_of :name, :repo_id
  validates :name, uniqueness: {scope: :repo_id}

  belongs_to :repo

  has_many :unfollow_branches
  has_many :unfollowers, class_name: 'User', source: :user, through: :unfollow_branches
end
