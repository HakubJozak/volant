class UpdateAssignmentsCache < ActiveRecord::Migration
  def self.up
    ApplyForm.find(:all).each do |form|
      ApplyForm.update_cache_for(form.id)
      putc '.'
    end
  end

  def self.down
  end
end
