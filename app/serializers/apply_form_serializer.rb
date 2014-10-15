class ApplyFormSerializer < ActiveModel::Serializer
  attributes :id, :starred, :fee, :general_remarks, :motivation, :confirmed, :state, :cancelled, :created_at
  has_one :volunteer, embed: :ids, include: true
  has_one :payment, embed: :ids, include: true
  has_one :current_workcamp, embed: :ids, include: true
  has_many :workcamp_assignments, embed: :ids, include: false

  def state
    object.state.to_label.downcase
  end

end
