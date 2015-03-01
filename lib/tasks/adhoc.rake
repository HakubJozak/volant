namespace :adhoc do
  desc "TODO"
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
