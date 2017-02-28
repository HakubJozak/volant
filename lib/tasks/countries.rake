namespace :countries do
  task update_counts: :environment do
    Account.all.each do |a|
      a.update_countries_free_counts
    end
  end
end
