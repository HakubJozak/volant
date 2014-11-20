class WorkcampIntentionSerializer < Barbecue::BaseSerializer
  readonly_attributes :id
  writable_attributes :code, :description_en, :description_cz
end
