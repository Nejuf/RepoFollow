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
end
