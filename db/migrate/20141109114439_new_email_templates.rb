class NewEmailTemplates < ActiveRecord::Migration
  def change
    create_table :new_email_templates do |t|
      t.string   :action
      t.string   :title
      t.string   :to
      t.string   :cc
      t.string   :bcc, default: '{{user.email}}'
      t.string   :from, default: '{{user.email}}'
      t.string   :subject
      t.text     :body
      t.timestamps
    end



    Legacy::EmailTemplate.find_each do |tmpl|
      next if tmpl.action == 'mail'
      puts "Converting #{tmpl.action} email template"

      to = case tmpl.action.to_sym
           when :ask
             '{{organization.outgoing_email}}'
           else
             '{{volunteer.email}}'
           end

      body = if layout = Legacy::EmailTemplate.find_by_action(tmpl.wrap_into_template)
               layout.body.gsub(/\{\{content\}\}/,tmpl.body)
             else
               tmpl.body
             end

      EmailTemplate.create!(action: tmpl.action,
                            title: tmpl.description,
                            to: to,
                            subject: tmpl.subject,
                            body: body)
    end
  end
end
