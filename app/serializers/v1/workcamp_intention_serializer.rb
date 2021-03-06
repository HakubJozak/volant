class V1::WorkcampIntentionSerializer < ActiveModel::Serializer
  attributes :id, :code, :description

  def description
    object.description_cz
  end
end
