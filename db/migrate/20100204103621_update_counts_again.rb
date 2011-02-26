class UpdateCountsAgain < ActiveRecord::Migration
  def self.up
    camps = Outgoing::Workcamp.find(:all)
    size = camps.size
    puts "Updating #{camps.size} workcamps"

    camps.each_with_index do |wc,i|
      FreePlacesObserver.update_free_places(wc)
      wc.save!
      putc '.'

      if i % 50 == 0
        puts "#{i}/#{size}"
      else
        $stdout.flush
      end
    end
  end

  def self.down
  end
end
