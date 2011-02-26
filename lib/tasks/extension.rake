namespace :db do

  desc "Clean schema rebuild and refresh of test database"
  task :rebuild => [ "db:migrate:reset", "db:test:prepare"] do
  end

  desc "Guess incoming email addresses"
  task :incoming_emails => :environment do
    Organization.all.each do |org|
      org.emails.each do |contact|
        contact.update_attribute(:kind, contact.active? ? 'OUTGOING' : nil )
      end
    end
  end

  desc "Mangle sensitive data!"
  task :mangle => :environment do
    unless Rails.env == 'development'
      puts('Available only in development')
      exit
    else
      require 'faker'
    end

    Person.all.each do |v| 
      v.firstname = Faker::Name.first_name
      v.lastname = Faker::Name.last_name
      v.birthnumber =  Faker.numerify('##########')
      v.email = Faker::Internet.email
      v.phone = Faker::PhoneNumber.phone_number
      v.birthdate = (15 + rand(15)).years.ago
      v.emergency_name = Faker::Name.name
      v.emergency_day = Faker::PhoneNumber.phone_number
      v.emergency_night = Faker::PhoneNumber.phone_number

      [ '', 'contact_' ].each do |prefix|
        v.send("#{prefix}street=", Faker::Address.street_name)
        v.send("#{prefix}city=", Faker::Address.city)
      end
      
      v.save!
      putc('v') and $stdout.flush
    end

    Payment.all.each do |p|
      if p.bank?
        p.account = Faker.numerify('f##########')
      else
        p.account = ''
      end

      p.save(false)
      putc('p') and $stdout.flush
    end

    EmailContact.all.each do |c|
      c.address = Faker::Internet.email
      c.save
      putc('o') and $stdout.flush
    end

  end


end
