class WorkcampAssignmentsController < ApplicationController
  respond_to :json

  before_action :set_workcamp_assignment, only: [:show, :edit, :update, :destroy]

  def index
    was = workcamp_assignments.includes(:apply_form,:workcamp).find(params[:ids])
    render json: was, each_serializer: WorkcampAssignmentSerializer
  end

  def show
    respond_with(@wa)
  end

  # POST /workcamp_assignments
  def create
    wa = workcamp_assignments.new(workcamp_assignment_params)
    
    if wa.save
      render json: wa, serializer: WorkcampAssignmentSerializer
    else
      render_error(wa)      
    end
  end

  # PATCH/PUT /workcamp_assignments/1
  def update
    @wa.update(workcamp_assignment_params)
    @wa.apply_form.reload
    render json: @wa
  end

  # DELETE /workcamp_assignments/1
  def destroy
    @wa.destroy
    @wa.apply_form.reload
    render json: @wa
  end

  private

  def set_workcamp_assignment
    @wa = workcamp_assignments.find(params[:id])
  end

  # TODO SECURITY: scope by organization, scope organization by logged in user!
  def workcamp_assignment_params
    params[:workcamp_assignment].delete(:state)
    params[:workcamp_assignment].permit(:order,:accepted,:rejected,:infosheeted,:asked,:apply_form_id,:workcamp_id)
  end

  def workcamp_assignments
    Outgoing::WorkcampAssignment
  end
end
