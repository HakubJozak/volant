Factory.define :message do |f|
  f.to 'them@there.com'
  f.from 'me@there.com'
  f.subject 'something to say'
  f.body 'body' * 10
  f.action 'accept'
  f.association :user
end
