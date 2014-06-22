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
      @feed_dates << {date: date.to_s}
    end

    render 'index'
  end

  def authenticate_user
    redirect_to sign_up_path unless current_user
  end
end
