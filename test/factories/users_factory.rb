Factory.define :user do |u|
  u.login 'admin'
  u.firstname 'Jakub'
  u.lastname 'Hozak'
  u.locale 'en'
  u.email 'admin@inexsda.cz'
  u.password 'heslo'
  u.password_confirmation 'heslo'
  u.created_at 5.days.ago
end


