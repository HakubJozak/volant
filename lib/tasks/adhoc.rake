namespace :adhoc do
  desc "Computes durations for old workcamps"
  task set_durations: :environment do
    Workcamp.find_each do |wc|
      unless wc.duration
        wc.update_column :duration, wc.send(:computed_duration)

      end
    end
  end

end
