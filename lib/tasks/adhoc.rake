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

  task continents: :environment do
    CountryZone.all.each do |zone|
      zone.continent = case zone.name_en.downcase
                       when /europe/ then 'Europe'
                       when /africa/ then 'Africa'
                       when /asia/ then 'Asia'
                       when /america/ then zone.name_en
                       else 'Australia & Oceania'
                       end
      zone.save(validate: false)
    end
  end
end
