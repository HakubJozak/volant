module InexRules

  def self.organization_response_limit
    4.day.ago.to_date
  end

  # the latest time before workcamp start
  def self.infosheet_waiting_limit
    1.month.from_now.to_date
  end

end
