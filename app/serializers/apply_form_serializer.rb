class ApplyFormSerializer < ActiveModel::Serializer
  attributes :id, :starred, :fee, :general_remarks, :motivation, :confirmed, :state, :cancelled, :created_at
  has_one :volunteer, embed: :ids, include: true
  has_many :workcamp_assignments, embed: :ids, include: true

  def state
    object.state.to_label.downcase
  end

end
