Factory.define :country_zone do |f|
  f.sequence(:name_en) { |n| "Zone #{n}" }
  f.sequence(:name_cz) { |n| "Zone #{n}" }
end

Factory.define :country do |c|
  c.sequence(:name_cz) { |n| "Country#{n}" }
  c.sequence(:name_en) { |n| "Country#{n}" }
  c.sequence(:code) { |n| 'CX' }
  c.sequence(:triple_code) { |n| 'CXX' }
  c.association :country_zone
end


Factory.define :czech_republic, :parent => :country do |c|
  c.name_cz 'Ceska Republika'
  c.name_en 'Czech Republic'
  c.code 'CZ'
  c.triple_code 'CZE'
end
