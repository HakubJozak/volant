namespace :db do
  namespace :inex do

    task :all => [ "db:seed", :organizations, :workcamps, :members, :payments, :applications ] do
    end

    desc "Migrates organizations."
    task :organizations => :environment do
      # TODO - vyresit mazani organizace!
      p "Migrating organizations..."
      Partnership.delete_all
      EmailContact.delete_all
      Workcamp.destroy_all
      Organization.delete_all
      Old::Organization.migrate_all
      p "done."
    end

    desc "Migrates volunteers."
    task :members => :environment do
      p "Migrating volunteers..."
      WorkcampAssignment.delete_all
      Payment.delete_all
      ApplyForm.delete_all
      Volunteer.delete_all
      Old::Member.migrate_all(true)
      p "done."
    end


    desc "Migrates workcamps"
    task :workcamps => :environment do
      p "Migrating workcamps..."
      Workcamp.destroy_all
      Old::Workcamp.migrate_all
      p "done."
    end

    task :payments => :environment do
      p "Migrating payments"
      Payment.delete_all
      Old::Payment.migrate_all(true)
      p "done."
    end

    desc "Migrates application forms"
    task :applications => :environment do
      p "Migrating applications..."
      ApplyForm.destroy_all
      #Old::Application.find('2004-8754090026').migrate.save!
      Old::Application.migrate_all
      p "done."
    end


  end
end
