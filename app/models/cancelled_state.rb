class CancelledState < ApplyFormState

  def initialize(form)
    super(:cancelled, form.cancelled, form)
  end

  def info
    prefix = "apply_form_states.info.cancelled"
    params = { :time => @time.to_date }

    if @form.accepted and @form.accepted <= @form.cancelled
      to_wc = (@form.current_workcamp.begin.to_date - @form.cancelled.to_date) rescue '?'
      after_ac = (@form.cancelled.to_date - @form.accepted.to_date) rescue '?'

      params.update :to_wc_count => to_wc.to_i, :after_accept_count => after_ac.to_i

      # time_ago_in_words(3.minutes.from_now)
      Outgoing::ApplyForm.human_attribute_name("#{prefix}.after", params)
    else
      Outgoing::ApplyForm.human_attribute_name("#{prefix}.before", params)
    end

  end
end
