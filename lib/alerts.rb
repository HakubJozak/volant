module Alerts
  extend ActiveSupport::Concern

  # Alert - true if the response hadn't come in 4 days or more (given by InexRules).
  def waits_too_long?
    is?(:asked) and self.asked <= 4.days.ago.to_date
  end

  # Alert - true if the infosheet has not been sent and the workcamp starts in month or less (given by InexRules).
  def no_infosheet?
    latest_workcamp_start = 1.month.from_now.to_date

    if current_workcamp and current_workcamp.begin
      is?(:accepted) and not is?(:infosheeted) and (current_workcamp.begin <= latest_workcamp_start)
    end
  end

  def has_alerts?
    waits_too_long? or no_infosheet?
  end

end
