class ApplyFormSerializer < ActiveModel::Serializer
  attributes :id, :fee, :general_remarks, :motivation, :confirmed
end
