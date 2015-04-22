Factory.define :organization do |o|
  o.sequence(:name) { |n| "Organization#{n}" }
  o.code 'ABC'
  o.association :country
  o.networks { |n| (1..2).to_a.map { n.association(:network) } }
end


