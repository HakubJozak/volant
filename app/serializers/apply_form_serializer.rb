class ApplyFormSerializer < ActiveModel::Serializer
  attributes :id, :starred, :fee, :general_remarks,
  :motivation, :confirmed, :cancelled, :created_at,
  :state

  has_one :volunteer, embed: :ids, include: true
  has_one :payment, embed: :ids, include: true
  has_one :current_workcamp, embed: :ids, include: true, root: 'workcamps'
  has_one :current_assignment, embed: :ids, include: true, root: 'workcamp_assignments'
  has_many :workcamp_assignments, embed: :ids, include: false

  def state
    s = object.state
    { name: s.name,
      info: s.info,
      actions: s.actions }
  end
end
