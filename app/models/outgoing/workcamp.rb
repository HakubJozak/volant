require "#{Rails.root}/app/models/outgoing/workcamp_assignment"

module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors

    include Outgoing::FreePlacesUpdater
    before_save :update_free_places_for_workcamp

    validates_presence_of :name, :country, :organization, :publish_mode


    has_many :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::WorkcampAssignment'
    has_many :apply_forms, through: :workcamp_assignments, dependent: :destroy, class_name: 'Outgoing::ApplyForm'


    has_many :accepted_forms, -> { readonly.where("#{ApplyForm.table_name}.cancelled IS NULL and #{WorkcampAssignment.table_name}.accepted IS NOT NULL") }, through: :workcamp_assignments,             class_name: 'Outgoing::ApplyForm',
             source: :apply_form


  end
end
