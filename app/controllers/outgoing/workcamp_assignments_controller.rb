module Outgoing
  class WorkcampAssignmentsController < ApplicationController

    active_scaffold 'Outgoing::WorkcampAssignment' do |config|
      config.columns = [ :order,
                         :workcamp,
                         :accepted,
                         :rejected,
                         :asked,
                         :infosheeted
                       ]

      config.list.columns = [ :order,
                              :code,
                              :workcamp,
                              :from,
                              :to,
                              :accepted,
                              :rejected,
                              :asked,
                              :infosheeted ]

      config.list.sorting = { :order => 'ASC' }

      highlight_required(config, Outgoing::WorkcampAssignment)
    end

    protected

    # Presets the order of a new workcamp assignment and creates it.
    def do_new
      # called only nested in apply forms
      form = ApplyForm.find(nested_parent_id.to_i)

      if form.workcamp_assignments.size > 0
        order = form.workcamp_assignments.maximum(:order) + 1
      else
        order = 1
      end

      @record = WorkcampAssignment.new( :order => order, :apply_form => form  )
    end

  end
end
