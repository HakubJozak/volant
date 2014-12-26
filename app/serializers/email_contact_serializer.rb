class EmailContactSerializer < ApplicationSerializer
  attributes :id, :address, :name, :notes, :kind, :active, :organization_id
end
