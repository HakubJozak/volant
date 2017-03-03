class EmailTemplateSerializer < ApplicationSerializer
  attributes :id, :action, :title, :subject, :body, :to, :from, :cc, :bcc
end

# == Schema Information
#
# Table name: new_email_templates
#
#  id         :integer          not null, primary key
#  action     :string(255)
#  title      :string(255)
#  to         :string(255)
#  cc         :string(255)
#  bcc        :string(255)      default("{{user.email}}")
#  from       :string(255)      default("{{user.email}}")
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#
