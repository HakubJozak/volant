class ImportChangeSerializer < Barbecue::BaseSerializer
  has_one :workcamp, embed: :id, include: false
  readonly_attributes :id
  writable_attributes :field, :value
end
