class PayloadSerializer < ActiveModel::Serializer
  has_many :workcamps, embed: :ids, include: true, serializer: WorkcampSerializer  
  has_many :apply_forms, embed: :ids, include: true, serializer: ApplyFormSerializer
  has_many :messages, embed: :ids, include: true, serializer: MessageSerializer
  has_many :workcamp_assignments, embed: :ids, include: true, serializer: WorkcampAssignmentSerializer

  [ :messages, :apply_forms, :workcamp_assignments, :workcamps ].each do |name|
    define_method(name) do
      object.send(name) || []
    end  
  end
  
end
