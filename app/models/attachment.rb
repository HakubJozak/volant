class Attachment < ActiveRecord::Base
  belongs_to :message
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
