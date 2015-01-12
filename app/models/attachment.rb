class Attachment < ActiveRecord::Base
  belongs_to :message
  mount_uploader :file, AttachmentUploader

  def has_data?
    file != nil
  end

  def data
    file.read if file
  end

  def filename
    file_identifier || 'untitled'
  end
end

class VefAttachment < Attachment
  belongs_to :apply_form
  validates_presence_of :apply_form
  include CzechUtils

  def has_data?
    file != nil
  end

  def data
    '<vef></vef>'
  end

  def filename
    if v = apply_form.volunteer
      stripped = strip_cs_chars("#{v.firstname}_#{v.lastname}_#{v.birthdate}")
      "VEF_#{stripped.underscore}.xml"
    else
      'vef.xml'
    end
  end
end

class InfosheetAttachment < Attachment
  belongs_to :workcamp
  validates_presence_of :workcamp

  def has_data?
    file != nil
  end

  def data
    '<vef></vef>'
  end

  def filename
    'vef.xml'
  end  
end
