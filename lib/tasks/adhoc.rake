namespace :adhoc do
  task confirmed_emails: :environment do
    [ 'incoming/', 'ltv/', '' ].each do |prefix|
      EmailTemplate.create!( action: "#{prefix}confirm",
                             title: 'Cofirmation response',
                             subject: "Have a Good Trip!",
                             cc: '{{workcamp.allApplicationsEmails}}',
                             body: "Thanks for your confirmation.\n\nHave fun!\n\n{{user.firstname}}",
                             to: '{{application.email}}',
                             from: '{{user.email}}') 
    end
  end

  task ltv_mails: :environment do
    EmailTemplate.find_each do |old|
      EmailTemplate.create!(action: "ltv/#{old.action}",
                            title: "LTV: #{old.title}",
                            to: old.to,
                            cc: old.cc,
                            bcc: old.bcc,
                            subject: old.subject,
                            body: old.body)
    end
  end
end
