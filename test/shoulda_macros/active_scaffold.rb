module Shoulda
  module Macros
    def should_be_active_scaffold
      should_respond_with :success
      should_render_with_layout 'application'      
    end
  end
end
