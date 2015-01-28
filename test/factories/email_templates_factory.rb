Factory.define :email_template do |et|
  et.from 'me@here.com'
  et.to 'them@there.net'
  et.action 'testing'
  et.subject 'Default subject'
  et.body 'Body is not important'
  et.title 'Testing template'
end
