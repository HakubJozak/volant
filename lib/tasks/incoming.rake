namespace :incoming do

  task all:  [ :participants, :apply_forms, :emails, :new_templates, :refresh_placement ] do
    puts 'Done.'
  end

  task refresh_placement: :environment do
    Workcamp.year(2015).find_each do |wc|
      wc.save(validate: false)
      puts wc.name
    end
  end

  task outgoing: :environment do
    inex = Organization.find_by_code('SDA')
    Outgoing::ApplyForm.update_all(country_id: inex.country, organization_id: inex)
  end

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

  task new_templates: :environment do
    EmailTemplate.create!( action: 'incoming/infosheet_all',
                           title: 'INCOMING: Send infosheet to all organizations involved',
                           subject: "Infosheet for '{{workcamp.code}} {{{workcamp.name}}}",
                           cc: '{{workcamp.allApplicationsEmails}}',
                           body: 'We are sending you the infosheets.',
                           bcc: '{{workcamp.allOrganizationsEmails}}',
                           from: '{{user.email}}')

    [ :ask, :accept, :infosheet, :submitted, :reject ].each do |action|
      old = EmailTemplate.find_by_action!(action)
      new = EmailTemplate.create!(action: "incoming/#{old.action}",
                                  title: "INCOMING: #{old.title}",
                                  to: old.to,
                                  cc: old.cc,
                                  bcc: old.bcc,
                                  subject: old.subject,
                                  body: old.body)
      puts "Created #{new.action}"
    end
  end


  desc 'Converts all Participants into Incoming::ApplyForm and assignments'
  task participants: :environment do
    Incoming::Participant.find_each do |p|
      form = p.apply_form
      form.fee = 0
      form.country = p.country
      form.organization = p.organization
      form.tag_list = p.tag_list
      form.comments = form.comments.to_s + p.note.to_s

      if p.workcamp
        form.workcamp_assignments.create!(workcamp: p.workcamp, accepted: form.created_at)
        form.save(validate: false)
      else
        puts "#{p.name} (#{p.id}) has no workcamp"
      end

      putc '.'
    end
  end


  desc 'Copies current data from volunteer into application'
  task apply_forms: :environment do
    STRINGS = [ :firstname, :lastname, :gender,
                :email,:phone,:birthnumber,:occupation,:account,
                :emergency_name,:emergency_day,:emergency_email,
                :speak_well,:speak_some,:fax,:street,
                :city,:zipcode,:contact_street,
                :contact_city,:contact_zipcode,
                :birthplace,:nationality ]

    TEXTS = [ :special_needs, :past_experience, :note ]

    #    ApplyForm.year(2015).find_each do |form|
    ApplyForm.find_each do |form|
      puts "#{form.volunteer.try(:name)}(#{form.id})"
      source = form.volunteer || form.participant

      if source
        (TEXTS + STRINGS + [:birthdate,:country_id,:organization_id]).flatten.each do |attr|
          form.send "#{attr}=", source.send(attr)
        end

        form.comments = form.comments.to_s + source.comments.to_s
        form.save(validate: false)
      else
        puts "Skipping #{form.id}"
      end
    end
  end
end
