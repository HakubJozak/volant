Factory.define :user do |u|
  u.first_name 'Jakub'
  u.last_name 'Hozak'
  u.sequence(:email) { |i| "#{i}@inexsda.cz" }
  u.password 'hesloheslo'
  u.password_confirmation 'hesloheslo'
  u.created_at 5.days.ago
  # TODO
  # u.account
end
