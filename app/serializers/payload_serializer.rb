class PayloadSerializer < ActiveModel::Serializer
  has_many :apply_forms, embed: :ids, include: true, serializer: ApplyFormSerializer
  has_many :messages, embed: :ids, include: true, serializer: MessageSerializer
  has_many :workcamp_assignments, embed: :ids, include: true, serializer: WorkcampAssignmentSerializer

end
