Factory.define :user do |u|
  u.first_name 'Jakub'
  u.last_name 'Hozak'
  u.email 'admin@inexsda.cz'
  u.password 'hesloheslo'
  u.password_confirmation 'hesloheslo'
  u.created_at 5.days.ago
end
