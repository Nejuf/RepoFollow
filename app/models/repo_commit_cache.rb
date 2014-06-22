# Keeps track of which date's commits have been cached for a given repo
class RepoCommitCache
  include Mongoid::Document

  field :repo_full_name, type: String
  field :dates, type: Array, default: []

  validates_presence_of :repo_full_name
  validates_uniqueness_of :repo_full_name
end
