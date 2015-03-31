class AddSendingOrganization < ActiveRecord::Migration
  def change
    add_column :apply_forms, :organization_id, :integer
    add_column :apply_forms, :country_id, :integer

    Incoming::Participant.find_each do |p|
      form = p.apply_form
      form.country = p.country
      form.organization = p.organization

      if p.workcamp
        form.workcamp_assignments.create!(workcamp: p.workcamp,order: 1, accepted: form.created_at)
        form.save!
      else
        puts "#{p.name} (#{p.id})"
      end
      
      putc '.'
    end
  end
end
