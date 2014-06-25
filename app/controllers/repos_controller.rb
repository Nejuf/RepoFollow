class ReposController < ApplicationController
  def follow
    @repo = Repo.where(github_uid: params[:github_uid]).first
    load_git_repo! unless @repo

    follow = FollowRepo.new
    follow.repo = @repo
    follow.user = current_user

    if follow.save
      render json: {}, status: :ok
    else
      render json: {errors: @follow.errors}
    end
  end

  def index
    @repos = current_user.followed_repos
    render 'index'
  end

  def edit
    @repo = Repo.find(params[:id])
    @branches = load_git_repo_branches!(@repo)
    render 'edit'
  end

private
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
end
