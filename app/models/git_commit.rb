class GitCommit
  include Mongoid::Document

  field :sha, type: String

  validates_presence_of :sha
  validates_uniqueness_of :sha

  # Most of the fields are dynamic and will match exactly what is returned by the Github API
  # sha is how we will distinguish between commits

  # :repo_full_name and :date are not part of the Github commit object,
  # and are simply to make it easier for us to find commits
  field :repo_full_name, type: String
  field :date, type: String

  validates_presence_of :repo_full_name
  validates_presence_of :date

  # TODO :repo_full_name is probably a good candidate for an index
end
