class MessageSerializer < ActiveModel::Serializer
  has_one :email_template, embed: :ids, include: false
#  has_one :apply_form, embed: :ids, include: false
#  has_one :workcamp_assignment, embed: :ids, include: true
  has_one :user, embed: :ids, include: false

  def self.public_attributes
    [:id, :to, :from, :subject, :body, :sent_at, :action]
  end

  attributes *MessageSerializer.public_attributes


end
