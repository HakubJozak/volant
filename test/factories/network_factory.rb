Factory.define :network do |n|
  n.sequence(:name) { |n| "Network#{n}" }  
end
