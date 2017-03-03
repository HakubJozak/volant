class ImportChange < ActiveRecord::Base

  belongs_to :workcamp #, :class_name => 'Outgoing::Workcamp'
  before_save :regenerate_diff

  def apply!
    ImportChange.transaction do
      self.apply
      self.destroy
    end
  end

  def apply(wc = self.workcamp)
    wc.send("#{self.field}=", self.value.to_s)
  end

  def regenerate_diff
    Differ.format = :html
    self.diff = Differ.diff_by_word(ERB::Util.html_escape(new.to_s),
                                    ERB::Util.html_escape(old.to_s)).to_s
  end

  def old
    workcamp.send(field)
  end

  def new
    value
  end

end

# == Schema Information
#
# Table name: import_changes
#
#  id          :integer          not null, primary key
#  field       :string(255)      not null
#  value       :text             not null
#  diff        :text
#  workcamp_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#
