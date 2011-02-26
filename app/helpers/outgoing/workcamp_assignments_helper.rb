module Outgoing::WorkcampAssignmentsHelper

#  ApplicationHelper::date_fields :rejected, :accepted

  def code_column(wa)
    wa.workcamp.code
  end

  def from_column(wa)
    wa.workcamp.begin ? I18n.localize(wa.workcamp.begin.to_date) : '-'
  end

  def to_column(wa)
    wa.workcamp.end ? I18n.localize(wa.workcamp.end.to_date) : '-'
  end

  def workcamp_column(wa)
    wa.workcamp.name
  end

  def workcamp_form_column(record, input_name)
    belongs_to_auto_completer_as( :workcamp, :name)
  end

end
