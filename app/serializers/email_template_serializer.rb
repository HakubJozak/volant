class EmailTemplateSerializer < ActiveModel::Serializer

  def self.public_attributes
   [ :action, :title, :subject, :body, :to, :from, :cc, :bcc ]
  end

  def self.private_attributes
   [ :id ]
  end

  attributes *[ EmailTemplateSerializer.public_attributes, EmailTemplateSerializer.private_attributes ].flatten

end
