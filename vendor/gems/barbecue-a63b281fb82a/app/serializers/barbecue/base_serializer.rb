class Barbecue::BaseSerializer < ActiveModel::Serializer

  cattr_reader :readonly
  cattr_reader :writable

  def self.writable_attributes(*names)
    self.attributes(*names)
    @@writable ||= []
    @@writable.concat(names)
  end

  def self.readonly_attributes(*names)
    self.attributes(*names)
    @@readonly ||= []
    @@readonly.concat(names)
  end

  def self.all_attributes
    [ @@readonly, @@writable ].compact.flatten
  end

  # def self.has_many(name,options = {})
  #   if name == :exhibitions
  #     options.merge!(serializer: V1::ExhibitionSerializer)
  #   end
  #   super(name,options)
  # end

end
