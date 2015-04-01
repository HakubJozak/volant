namespace :adhoc do
  task incoming: :environment do
  STRINGS = [ :firstname, :lastname, :gender,  
        :email,:phone,:birthnumber,:occupation,:account,
        :emergency_name,:emergency_day,:emergency_night,
        :speak_well,:speak_some,:fax,:street,
        :city,:zipcode,:contact_street,
        :contact_city,:contact_zipcode,
        :birthplace,:nationality ]

  TEXTS = [ :special_needs, :past_experience, :comments, :note ]


    Incoming::Participant.find_each do |p|
      form = p.apply_form
      form.country = p.country
      form.organization = p.organization

      if p.workcamp
        form.workcamp_assignments.create!(workcamp: p.workcamp,order: 1, accepted: form.created_at)
        form.save(validate: false)
      else
        puts "#{p.name} (#{p.id}) has no workcamp"
      end
      
      putc '.'
    end

    ApplyForm.year(2015).find_each do |form|
      puts "#{form.name}(#{form.id})"
      source = form.volunteer || form.participant
      
      (TEXTS + STRINGS + [:birthdate]).flatten.each do |attr|
        form.send "#{attr}=", source.send(attr)
      end
      
      form.save(validate: false)
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
