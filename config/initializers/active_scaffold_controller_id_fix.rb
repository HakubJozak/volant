module ActiveScaffold
  module Helpers
    module IdHelpers
      def controller_id
        # Adding 'as_' in the beggining fixes JS crash on destroy of the nested record
        @controller_id ||= 'as_' + (params[:parent_controller] || params[:eid] || params[:controller]).gsub("/", "__")
      end
    end
  end
end
