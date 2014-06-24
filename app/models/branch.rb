class Branch < ActiveRecord::Base
  attr_accessible :name, :repo_id

  validates_presence_of :name, :repo_id
  validates :name, uniqueness: {scope: :repo_id}

  belongs_to :repo

  has_many :follow_branches
  has_many :followers, class_name: 'User', source: :user, through: :follow_branches
end
