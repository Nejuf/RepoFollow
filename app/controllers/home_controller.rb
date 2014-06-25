class HomeController < ApplicationController
  before_filter :authenticate_user

  def index
    end_date = params[:end] ? Date.parse(params[:end]) : Date.today
    end_date = Date.today if end_date > Date.today
    start_date = params[:start] ? Date.parse(params[:start]) : end_date.prev_day(7)
    start_date = end_date.prev_day(7) if start_date > end_date

    @older_url = "/?start=#{start_date.prev_day(8)}&end=#{start_date.prev_day}" # TODO determine earliest feed date
    @newer_url = "/?start=#{end_date.next_day}&end=#{end_date.next_day(8)}" if end_date < Date.today

    @feed_dates = []

    start_date.upto(end_date).each do |date|
      date_commits = []
      current_user.followed_repos.each do |repo|
        date_commits += retrieve_commits(repo.full_name, date.to_s)
      end
      # TODO Sort date_commits
      @feed_dates << {date: date.to_s, commits: date_commits}
    end

    render 'index'
  end

  def retrieve_commits(repo_full_name, date_string)
    if commits_cached?(repo_full_name, date_string)
      return GitCommit.where(repo_full_name: repo_full_name, date: date_string).entries
    else
      commits = Octokit.commits_on(repo_full_name, date_string)
      # TODO either turn on Octokit auto_paginate or fetch the remaining commits when amount exceeds per_page limit
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

  def authenticate_user
    redirect_to sign_up_path unless current_user
  end
end
