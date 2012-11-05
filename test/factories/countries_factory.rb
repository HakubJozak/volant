Factory.define :country do |c|
  c.sequence(:name_cs) { |n| "Country#{n}" }
  c.sequence(:name_en) { |n| "Country#{n}" }
  c.sequence(:code) { |n| 'CX' }
  c.sequence(:triple_code) { |n| 'CXX' }
end


Factory.define :czech_republic, :parent => :country do |c|
  c.name_cs 'Ceska Republika'
  c.name_en 'Czech Republic'
  c.code 'CZ'
  c.triple_code 'CZE'
end
