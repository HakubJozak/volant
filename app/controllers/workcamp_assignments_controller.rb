class WorkcampAssignmentsController < ApplicationController
  respond_to :json

  before_action :set_workcamp_assignment, only: [:show, :edit, :update, :destroy]


  # POST /workcamp_assignments
  def create
    @wa = Outgoing::WorkcampAssignment.new(workcamp_assignment_params)
    @wa.save
    # respond_with(@wa)
    render json: wa, serializer: WorkcampAssignmentsSerializer
  end

  # PATCH/PUT /workcamp_assignments/1
  def update
    @wa.update(workcamp_assignment_params)
    respond_with(@wa.reload)
  end

  # DELETE /workcamp_assignments/1
  def destroy
    @wa.destroy
    respond_with(@wa)
  end

  private

  def set_workcamp_assignment
    @wa = Outgoing::WorkcampAssignment.find(params[:id])
  end

  # TODO SECURITY: scope by organization, scope organization by logged in user!
  def workcamp_assignment_params
    params[:workcamp_assignment].delete(:state)
    params[:workcamp_assignment].permit(:order,:accepted,:rejected,:infosheeted,:asked,:apply_form_id,:workcamp_id)
  end
end
