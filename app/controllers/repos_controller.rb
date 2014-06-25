class ReposController < ApplicationController
  include GithubHelper

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

  def follow_branch
    @repo = Repo.find(params[:repo_id])

    branch = Branch.where(repo_id: @repo.id, name: params[:branch_name]).first_or_create

    unfollow = UnfollowBranch.where(branch_id: branch.id, user_id: current_user.id).first

    unless unfollow.nil? || unfollow.destroy
      flash_message(:error, "Could not follow branch: #{branch ? branch.name : ''}")
    end

    invalidate_cache_commits(@repo.full_name, nil, true)
    redirect_to edit_repo_path(@repo)
  end

  def unfollow_branch
    @repo = Repo.find(params[:repo_id])

    branch = Branch.where(repo_id: @repo.id, name: params[:branch_name]).first_or_create

    unfollow = UnfollowBranch.new(branch_id: branch.id)
    unfollow.user = current_user

    unless unfollow.save
      flash_message(:error, "Could not unfollow branch: #{branch ? branch.name : ''}")
    end

    invalidate_cache_commits(@repo.full_name, nil, true)
    redirect_to edit_repo_path(@repo)
  end

  def index
    @repos = current_user.followed_repos
    render 'index'
  end

  def edit
    @repo = Repo.find(params[:id])
    @branches = load_git_repo_branches!(@repo)
    @followed_branches = @branches - current_user.unfollowed_branches
    @unfollowed_branches = current_user.unfollowed_branches
    # TODO as an optimization, we could maintain a has_unfollowed_branches boolean on FollowRepo and only query branch following or activity scoping if it's true
    render 'edit'
  end

end
