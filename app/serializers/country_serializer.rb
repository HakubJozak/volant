class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :triple_code

  def name
    # hard-wired English for now
    object.name_en
  end

  def self.public_attributes
   [ :name, :code, :triple_code ]
  end

  def self.private_attributes
   [ :id ]
  end

  attributes *[ CountrySerializer.public_attributes, CountrySerializer.private_attributes ].flatten

end
