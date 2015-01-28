Factory.define :import_change do |i|
  i.field 'name'
  i.value 'New name'
  i.association :workcamp
end
