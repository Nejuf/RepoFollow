module GithubHelper
  def create_pagination_links(response, replacement_path=nil)
    rels = response.rels

    @link_first = rels[:first].href if rels[:first]
    @link_prev = rels[:prev].href if rels[:prev]
    @link_next = rels[:next].href if rels[:next]
    @link_last = rels[:last].href if rels[:last]

    if replacement_path.present?
      @link_first.sub!(/^[^?]+/, replacement_path) if @link_first.present?
      @link_prev.sub!(/^[^?]+/, replacement_path) if @link_prev.present?
      @link_next.sub!(/^[^?]+/, replacement_path) if @link_next.present?
      @link_last.sub!(/^[^?]+/, replacement_path) if @link_last.present?
    end
  end

  def following_repo?(github_uid)
    repo = Repo.where(github_uid: github_uid).first
    return false unless repo.present? # If we don't have a copy of the repo, then no one is following it
    follow = FollowRepo.where(user_id: current_user.id, repo_id: repo.id).first
    follow.present?
  end

  def load_git_repo!
    begin
      github_repo = Octokit.get("repositories/#{params[:github_uid]}")
      # Finding a repo by github id is being to Octokit soon
      # https://github.com/octokit/octokit.rb/pull/485
      # Then we can just do Octokit.repository(params[:github_uid])
    rescue => e
      render json: {errors: e}, status: :unprocessable_entity
      return
    end

    @repo = Repo.new(github_uid: params[:github_uid])
    @repo.full_name = github_repo.full_name
    @repo.name = github_repo.name
    unless @repo.save
      render json: {errors: @repo.errors}, status: :unprocessable_entity
      return
    end
  end

  def load_git_repo_branches!(repo)
    # We need to load the branches each time in case new ones were created on the repo
    branches = []
    begin
      branches = Octokit.branches(repo.full_name)
    rescue => e
      Rails.logger.error "Error loading Github branches #{e}"
      raise
    end

    branches.map do |git_branch|
      Branch.where(name: git_branch[:name], repo_id: repo.id).first_or_create
    end
  end

  def retrieve_commits(repo_full_name, date_string)
    if commits_cached?(repo_full_name, date_string)
      return GitCommit.where(repo_full_name: repo_full_name, date: date_string).entries
    else
      commits = fetch_commits_from_github(repo_full_name)

      # Store the commits from the response as GitCommit objects in our Mongo database
      git_commits = commits.map do |commit|
        git_commit = GitCommit.where(sha: commit.sha).first || GitCommit.new
        # Must use to_attrs because Sawyer::Resource makes as_json and to_hash not recursively convert nested Sawyer::Resource objects
        git_commit.update_attributes(commit.to_attrs)

        git_commit.repo_full_name = repo_full_name
        git_commit.date = date_string
        git_commit.save!
        git_commit.reload # TODO Create a better workaround or fix. When the hash fields are set, the keys are symbols, but when Mongoid saves and loads the model, the keys are strings and the hashes do not have indifferent access.
      end
      cache_commits(repo_full_name, date_string)

      git_commits
    end
  end

  def commits_cached?(repo_full_name, date_string)
    cache = RepoCommitCache.where(repo_full_name: repo_full_name).first
    cache.present? && cache.dates.include?(date_string)
  end

  def cache_commits(repo_full_name, date_string)
    cache = RepoCommitCache.where(repo_full_name: repo_full_name).first_or_initialize
    cache.dates << date_string
    cache.save!
  end

  def fetch_commits_from_github(repo_full_name)
    repo = Repo.where(full_name: repo_full_name).first
    raise "Repo #{repo_full_name} was not found." if repo.nil?
    unfollowed_branches = current_user.unfollowed_branches.where(repo_id: repo.id)
    if unfollowed_branches.count == 0
      commits = Octokit.commits_on(repo_full_name, date_string)
      # TODO either turn on Octokit auto_paginate or fetch the remaining commits when amount exceeds per_page limit
    else
      followed_branches = load_git_repo_branches!(repo) - unfollowed_branches
      commits = {}
      followed_branches.each do |branch|
        branch_commits = Octokit.commits(repo_full_name, sha: branch.sha)
        branch_commits.each do |commit|
          commits[commit.sha] = commit unless commits.key?(commit.sha)
        end
      end
      commits = commits.values
    end

    commits
  end
end
