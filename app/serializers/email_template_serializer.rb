class EmailTemplateSerializer < Barbecue::BaseSerializer
  attributes :id, :action, :title, :subject, :body, :to, :from, :cc, :bcc
end
