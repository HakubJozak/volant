class ApplyFormSerializer < ApplicationSerializer
  attributes :id, :starred, :fee, :general_remarks,
  :motivation, :confirmed, :cancelled, :created_at,
  :state,
  :no_response_alert, :missing_infosheet_alert

  has_many :workcamp_assignments, embed: :ids, include: false

  has_one :volunteer, embed: :ids, include: true
  has_one :payment, embed: :ids, include: true
  has_many :tags, embed: :ids, include: true, serializer: TagSerializer

  has_one :current_workcamp, embed: :ids, include: true, root: 'workcamps'
  has_one :current_assignment, embed: :ids, include: true, root: 'workcamp_assignments'
  has_one :current_message, embed: :ids, include: false, root: 'messages'

  def no_response_alert
    object.waits_too_long?
  end

  def missing_infosheet_alert
    object.no_infosheet?
  end

  def current_message
    object.current_message
  end

  def state
    s = object.state
    { name: s.name,
      info: s.info,
      actions: s.actions }
  end
end
