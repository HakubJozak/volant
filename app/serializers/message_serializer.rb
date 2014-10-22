class MessageSerializer < ActiveModel::Serializer
  has_one :email_template, embed: :ids, include: false
#  has_one :apply_form, embed: :ids, include: false
#  has_one :workcamp_assignment, embed: :ids, include: true
  has_one :user, embed: :ids, include: false

  def self.public_attributes
    [ :to, :from, :subject, :body]
  end

  def self.private_attributes
    [:id, :sent_at, :action]
  end

  attributes *[ MessageSerializer.public_attributes, MessageSerializer.private_attributes ].flatten



end
