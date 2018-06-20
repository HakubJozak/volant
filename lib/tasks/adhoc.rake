namespace :adhoc do
  task emergency_emails: :environment do
     EmailTemplate.all.each { |t|
       unless t.title =~ (/^INCOMING|LTV/)
         t.update_column(:title, "OUTGOING: #{t.title}")
       end
     }

    common = {
      subject: "Are You OK with that?",
      body: "Please let us know.",
      to: '{{application.emergency_email}}',
      cc: '{{application.email}}'
    }

    EmailTemplate.create! common.merge(
                action: "emergency_confirmation",
                title:  'OUTGOING: Emergency contact confirmation',
                from: 'workcamp@inexsda.cz')

    EmailTemplate.create! common.merge(
                action: "ltv/emergency_confirmation",
                title: 'LTV: Emergency contact confirmation',
                from: 'ltv@inexsda.cz')
  end


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
