class UnfollowBranch < ActiveRecord::Base
  attr_accessible :branch_id, :user_id

  belongs_to :user
  belongs_to :branch

  validates_presence_of :user_id, :branch_id
  validates :user_id, uniqueness: {scope: :branch_id}
end
