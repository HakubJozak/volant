module Alerts

  # Alert - true if the response hadn't come in 4 days or more (given by InexRules).
  def waits_too_long?
    is?(:asked) and self.asked <= InexRules.organization_response_limit
  end

  # Alert - true if the infosheet has not been sent and the workcamp starts in month or less (given by InexRules).
  def no_infosheet?
    if current_workcamp and current_workcamp.begin
      is?(:accepted) and not is?(:infosheeted) and (current_workcamp.begin <= InexRules.infosheet_waiting_limit)
    end
  end

  def has_alerts?
    waits_too_long? or no_infosheet?
  end

end
