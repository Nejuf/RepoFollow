class GithubController < ApplicationController
  include GithubHelper

  def public_repos
    if params[:search].present?
      @repos = Octokit.search_repos(q: params[:search]).items
    elsif params[:q].present?
      parsed_query = JSON.parse(URI::decode(params[:q]).sub('=>', ':'))
      @repos = Octokit.search_repos(parsed_query, page: params[:page]).items
    else
      since = params[:since] || 0
      @repos = Octokit.all_repositories(since: since)
    end
    create_pagination_links(Octokit.last_response, github_public_repos_path)

    render 'public_repos'
  end
end
