class WorkcampAssignmentSerializer < ActiveModel::Serializer
  attributes :id, :order, :accepted, :rejected, :asked, :infosheeted, :state
  has_one :workcamp, embed: :ids, include: false, serializer: WorkcampSerializer
  has_one :apply_form, embed: :ids, include: false, serializer: ApplyFormSerializer
end
