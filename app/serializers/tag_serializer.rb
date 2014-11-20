class TagSerializer < Barbecue::BaseSerializer
  readonly_attributes :id
  writable_attributes :name, :color, :text_color
end
