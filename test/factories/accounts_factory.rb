Factory.define :account do |a|
  a.season_end Date.new(2015,3,15)
  a.organization_response_limit  4
  a.infosheet_waiting_limit 30
  a.association :organization
end
