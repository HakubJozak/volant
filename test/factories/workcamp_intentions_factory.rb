Factory.define :workcamp_intention do |i|
  i.sequence(:code) { |n| "INT#{n}" }
  i.description_cs 'ABC'
  i.description_en 'ABC'
end

Factory.define :edu, :parent => :workcamp_intention do |i|
  i.code 'EDU'
end
Factory.define :envi, :parent => :workcamp_intention do |i|
  i.code 'ENVI'
end


