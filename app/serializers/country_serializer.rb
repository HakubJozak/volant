class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name_en, :name_cz, :code, :triple_code

  def self.public_attributes
   [ :name_en, :name_cz, :code, :triple_code ]
  end

  def self.private_attributes
   [ :id ]
  end

  attributes *[ CountrySerializer.public_attributes, CountrySerializer.private_attributes ].flatten

end
