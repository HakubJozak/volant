module ImportChangesHelper

  def field_column(change)
    Outgoing::Workcamp.human_attribute_name(change.field)
  end

  def diff_column(change)
    content_tag :p, :class => 'diff' do
      change.diff
    end
  end
end
