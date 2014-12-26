class EmailTemplateSerializer < ApplicationSerializer
  attributes :id, :action, :title, :subject, :body, :to, :from, :cc, :bcc
end
