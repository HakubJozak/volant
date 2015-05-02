class WorkcampAssignmentSerializer < ApplicationSerializer
  attributes :id, :position, :accepted, :rejected, :asked, :infosheeted,:confirmed, :state

  has_one :workcamp, embed: :ids, include: true, serializer: WorkcampSerializer
  has_one :apply_form, embed: :ids, include: true, serializer: ApplyFormSerializer
end
