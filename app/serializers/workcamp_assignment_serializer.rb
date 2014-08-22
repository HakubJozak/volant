class WorkcampAssignmentSerializer < ActiveModel::Serializer
  attributes :id, :order, :accepted, :rejected, :asked, :infosheeted
end
