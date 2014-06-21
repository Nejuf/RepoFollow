class GithubController < ApplicationController
  include GithubHelper

  def public_repos
    since = params[:since] || 0
    @repos = Octokit.all_repositories(since: since)
    create_pagination_links(Octokit.last_response, github_public_repos_path)

    render 'public_repos'
  end
end
