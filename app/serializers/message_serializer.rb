class MessageSerializer < ActiveModel::Serializer
  has_one :email_template, embed: :ids, include: false
  has_one :apply_form, embed: :ids, include: false
  has_one :workcamp_assignment, embed: :ids, include: true

  attributes :id, :to, :from, :subject, :body, :user_id, :sent_at, :action
end
