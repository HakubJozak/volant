class WorkcampAssignmentSerializer < ApplicationSerializer
  attributes :id, :order, :accepted, :rejected, :asked, :infosheeted, :state
  has_one :workcamp, embed: :ids, include: false
  has_one :apply_form, embed: :ids, include: false
end
