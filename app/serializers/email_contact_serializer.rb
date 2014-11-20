class EmailContactSerializer < Barbecue::BaseSerializer
  attributes :id, :address, :name, :notes, :kind, :active, :organization_id
end
