namespace :adhoc do
  namespace :incoming do
    desc 'Replaces {{volunteer.*}} by {{application.*}}'
    task emails: :environment do
      EmailTemplate.find_each do |tmpl|
        puts tmpl.title

        [:to, :cc, :bcc, :from, :subject, :body ].each do |attr|
          if old = tmpl.send(attr)
            new = old.gsub(/\{\{\s*([a-z\-])*\s*volunteer\s*\.(.*)\}\}/,'{{\1 application.\2}}')
            tmpl.send "#{attr}=",new
            puts "-- #{attr} fixed"
          end
        end

        tmpl.save(validate: false)
      end
    end

    desc 'Converts all Participants into Incoming::ApplyForm'
    task participants: :environment do
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
    end


    task apply_forms: :environment do
      STRINGS = [ :firstname, :lastname, :gender,
                  :email,:phone,:birthnumber,:occupation,:account,
                  :emergency_name,:emergency_day,:emergency_night,
                  :speak_well,:speak_some,:fax,:street,
                  :city,:zipcode,:contact_street,
                  :contact_city,:contact_zipcode,
                  :birthplace,:nationality ]

      TEXTS = [ :special_needs, :past_experience, :comments, :note ]

      #    ApplyForm.year(2015).find_each do |form|
      ApplyForm.find_each do |form|
        puts "#{form.volunteer.try(:name)}(#{form.id})"
        source = form.volunteer || form.participant

        if source
          (TEXTS + STRINGS + [:birthdate]).flatten.each do |attr|
            form.send "#{attr}=", source.send(attr)
          end

          form.save(validate: false)
        else
          puts "Skipping #{form.id}"
        end
      end
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
