class MessageSerializer < Barbecue::BaseSerializer
  has_one :apply_form, embed: :ids, include: false
  has_one :user, embed: :ids, include: true

  def self.public_attributes
    [ :to, :from, :cc, :bcc, :subject, :body, :html_body, :user_id, :email_template_id,  :action]
  end

  def self.private_attributes
    [:id, :sent_at, :created_at]
  end

  attributes *[ MessageSerializer.public_attributes, MessageSerializer.private_attributes ].flatten
end
