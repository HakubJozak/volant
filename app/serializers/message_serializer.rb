class MessageSerializer < ApplicationSerializer
  has_one :apply_form, embed: :ids, include: false
  has_one :user, embed: :ids, include: true
  has_many :attachments, embed: :ids, include: true, serializer: AttachmentSerializer

  attributes :id, :sent_at, :created_at, :to, :from, :cc, :bcc, :subject, :body, :html_body, :user_id, :email_template_id,  :action
end
