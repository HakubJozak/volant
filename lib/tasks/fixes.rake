namespace :fix do

  # TODO - delete all by tag
  # import file

  desc "Guess workcamps with wrong characters inside"
  task :guess_bastards => :environment do
    Tag.find_by_name('Alliance.xml').taggings.each do |t|
      wc = Outgoing::Workcamp.find(t.taggable_id)
      contains_garbage?(wc)
    end
  end

  def contains_garbage?(wc)
    coder = HTMLEntities.new
    suspects = []

    [ :name, :description, :train, :airport, :accomodation, :area, :region ].each do |attr|
      coder.decode(wc.send(attr)).mb_chars.each_char do |c|
        suspects << c if c.ord > 122
      end
    end

    puts "#{wc.code}:" + suspects.join(',') unless suspects.empty?
  end

  desc 'Adhoc garbage'
  task :garbage => :environment do
    fix_one(26808)
#    Tag.find_by_name('Alliance.xml').taggings.each do |t|
#      fix_one(t.taggable_id)
#    end
  end

  def fix_one(id)
    wc = Outgoing::Workcamp.find(id)

    [ :name, :description, :airport, :train ].each do |attr|
      s = wc.send(attr)
      wc.send("#{attr.to_s}=", s.gsub("","'")) if s
    end

    wc.save
  end

  desc "Wrong participants to bookings"
  task :bookings => :environment do
    Incoming::Workcamp.all.each do |wc|
      wc.participants.each do |p|
	if p.lastname.downcase.strip.starts_with?('reservace')
          puts p.lastname
          wc.bookings.create(:country => p.country,
                             :organization => p.organization,
                             :gender => p.gender)
        end
      end
    end
  end

  desc 'Delete all "reservace" participants'
  task :kill_bookings => :environment do
    Incoming::Workcamp.all.each do |wc|
      wc.participants.each do |p|
        if p.lastname.downcase.strip.starts_with?('reservace')
          #puts p.lastname
          wc.participants.delete(p)
        end
      end
    end
  end

end
