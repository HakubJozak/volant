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

  task :unlock => :environment do
    only_in_development!
    User.all.each do |u|
      puts "Unlocking #{u.email}"
      u.update_attributes(password: 'password')
    end
  end
  

  desc "Mangle sensitive data!"
  task :mangle => :environment do
    only_in_development!

    bar = ProgressBar.create(:title => "People", :total => Person.count)
    Person.find_each do |v|
      v.firstname = Faker::Name.first_name
      v.lastname = Faker::Name.last_name
      v.birthnumber = Faker::Number.number(10)
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


      if v.respond_to?(:apply_forms)
        v.apply_forms.each do |f|
          f.firstname = v.firstname
          f.lastname = v.lastname
          f.birthnumber = v.birthnumber
          f.email = v.email
          f.phone = v.phone
          f.birthdate = v.birthdate
          f.emergency_name = v.emergency_name
          f.emergency_day = v.emergency_day
          f.emergency_night = v.emergency_night
          f.street = v.street
          f.city = v.city
          f.street = v.contact_street
          f.city = v.contact_city
          f.save(validate: false)
        end
      end

      v.save!
      bar.increment
    end

    bar = ProgressBar.create(:title => "Payments", :total => Payment.count)
    Payment.find_each do |p|
      account = if p.bank?
        p.account = Faker::Number.number(10)
      else
        p.account = nil
      end

      p.update_column(:account, account)
      bar.increment
    end

    bar = ProgressBar.create(:title => "Emails", :total => EmailContact.count)
    EmailContact.find_each do |c|
      c.address = Faker::Internet.email
      c.save
      bar.increment
    end
  end

  private

  def only_in_development!
    unless Rails.env == 'development'
      puts('Available only in development')
      exit
    else
      require 'ruby-progressbar'
      require 'faker'
    end
  end

end
