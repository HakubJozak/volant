class EmailTemplateSerializer < ActiveModel::Serializer

  def self.public_attributes
   [ :action, :description, :subject, :body, :wrap_into_template ]
  end

  def self.private_attributes
   [ :id ]
  end

  attributes *[ EmailTemplateSerializer.public_attributes, EmailTemplateSerializer.private_attributes ].flatten

end
