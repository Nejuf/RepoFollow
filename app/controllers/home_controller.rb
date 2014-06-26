class HomeController < ApplicationController
  include GithubHelper

  before_filter :authenticate_user

  MAX_DATE_RANGE = 3

  def index
    end_date = params[:end] ? Date.parse(params[:end]) : Date.today
    end_date = Date.today if end_date > Date.today
    start_date = params[:start] ? Date.parse(params[:start]) : end_date.prev_day(MAX_DATE_RANGE-1)
    start_date = end_date.prev_day(MAX_DATE_RANGE-1) if start_date > end_date

    @older_url = "/?start=#{start_date.prev_day(MAX_DATE_RANGE)}&end=#{start_date.prev_day}" if start_date > Date.parse('2005-04-07') #Git's initial release
    @newer_url = "/?start=#{end_date.next_day}&end=#{end_date.next_day(MAX_DATE_RANGE)}" if end_date < Date.today

    @dates = start_date.upto(end_date)

    respond_to do |format|
      format.html { render 'index'}
      format.json do
        feed_dates = []

        @dates.each do |date|
          date_commits = []
          current_user.followed_repos.each do |repo|
            date_commits += retrieve_commits(repo.full_name, date.to_s)
          end
          date_commits.sort! do |d1, d2|
            d1['commit.author.date'].to_s(:time) <=> d2['commit.author.date'].to_s(:time)
          end
          feed_dates << {date: date.to_s, commits: date_commits}
        end

        render json: feed_dates
      end
    end
  end

  def authenticate_user
    redirect_to sign_up_path unless current_user
  end
end
