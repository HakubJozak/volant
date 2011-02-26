Factory.define :workcamp do |w|
  w.sequence(:code) { |n| "ORG#{n}" }
  w.sequence(:name) { |n| "Dummy name #{n}" }
  w.country { Country.first }
  w.organization { Organization.first }
  w.intentions {|i| (1..3).to_a.map { i.association(:workcamp_intention) } }
  w.language "English"
  w.begin 20.days.from_now
  w.end 1.month.from_now
  w.capacity 10
  w.places 2
  w.places_for_females 2
  w.places_for_males 2
  w.minimal_age 18
  w.maximal_age 26
  w.area "Xaverov u Sázavy"
  w.accomodation "na Paloučku"
  w.workdesc "pití alkoholu ve velkém"
  w.notes "pouze abstinenti"
  w.description "zabijačka a Silvestr"
end

Factory.define :incoming_workcamp, :class => Incoming::Workcamp, :parent => :workcamp do |wc|
end

Factory.define :outgoing_workcamp, :class => Outgoing::Workcamp, :parent => :workcamp do |wc|
end
