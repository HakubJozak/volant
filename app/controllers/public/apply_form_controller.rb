class Public::ApplyFormsController < Public::BaseController

  def index
    redirect_to :action => :apply
  end

  def apply
     if params[:apply_form]
        @apply_form = ApplyForm.new(params[:apply_form])

        # FIXME - remove 'unless' - it shouldn't be neccessary
        @apply_form.add_workcamp( @cart.workcamps_ids) unless @cart.empty?

        if @apply_form.save

          # submission to remote system does not affect result of the action
          @apply_form.submit

          flash[:apply_form] = @apply_form
          redirect_to :action => :success
        end
     else
        @apply_form = ApplyForm.new( :emergency_day => '+420',
                                     :emergency_night => '+420',
                                     :phone => '+420')
     end
  end

  def success
    @apply_form = flash[:apply_form]
  end

end
