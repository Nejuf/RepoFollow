module HomeHelper

  def has_feed_entries?
    @feed_dates.any? { |date_info| date_info[:commits].present?  }
  end

  def showing_recent_activity?
    Date.parse(@feed_dates.last[:date]) >= Date.today
  end
end
