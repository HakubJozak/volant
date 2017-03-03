class MessageSerializer < ApplicationSerializer
  has_one :apply_form, embed: :ids, include: true
  has_one :workcamp, embed: :ids, include: true  
  has_one :user, embed: :ids, include: true
  has_many :attachments, embed: :ids, include: true, serializer: AttachmentSerializer

  attributes :id, :sent_at, :created_at, :to, :from, :cc, :bcc, :subject, :body, :html_body, :user_id, :email_template_id,  :action
end

# == Schema Information
#
# Table name: messages
#
#  id                :integer          not null, primary key
#  to                :string(65536)
#  from              :string(65536)
#  subject           :string(255)
#  body              :text
#  action            :string(255)
#  user_id           :integer          not null
#  email_template_id :integer
#  workcamp_id       :integer
#  sent_at           :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  apply_form_id     :integer
#  html_body         :text
#  cc                :string(65536)
#  bcc               :string(65536)
#
