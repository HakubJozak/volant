class EmailContactSerializer < ActiveModel::Serializer
  attributes :id, :address, :name, :notes, :kind, :active, :organization_id
end
