class AttachmentSerializer < ApplicationSerializer
  attributes :id, :url, :filename, :type
  has_one :message, embed: :ids, include: false
  has_one :apply_form, embed: :ids, include: false
  has_one :workcamp, embed: :ids, include: false

  def filename
    object.filename
  end

  def url
    object.file.try(:url)
  end

  def workcamp
    object.workcamp if object.respond_to?(:workcamp)
  end

  def apply_form
    object.apply_form if object.respond_to?(:apply_form)
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
