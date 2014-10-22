Factory.define :message do |f|
  f.sequence(:to) { |n| "them#{n}@there.com" }
  f.sequence(:from) { |n| "me#{n}@here.com" }
  f.subject 'something to say'
  f.body 'body' * 10
  f.action 'accept'
  f.association :user
end
