class InfosheetAttachment < Attachment
  belongs_to :workcamp
  validates_presence_of :workcamp

  def has_data?
    raise NotImplemented
  end

  def data
    raise NotImplemented
  end

  def filename
    raise NotImplemented
  end  
end

# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  file          :string(255)
#  type          :string(255)      default("Attachment"), not null
#  message_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  workcamp_id   :integer
#  apply_form_id :integer
#
