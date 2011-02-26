# Just to override the pagination looks.
module ActiveScaffold
  module Helpers
    module PaginationHelpers
      def pagination_ajax_links(current_page, params, window_size)
        start_number = current_page.number - window_size
        end_number = current_page.number + window_size
        start_number = 1 if start_number <= 0
        end_number = current_page.pager.last.number if end_number > current_page.pager.last.number

        html = []
        html << pagination_ajax_link(1, params) unless start_number == 1
        html << ".." unless start_number <= 2
        start_number.upto(end_number) do |num|
          if current_page.number == num
            # CHANGED!
            html << '<span class="current_page">'
            html << num
            html << '</span>'
          else
            html << pagination_ajax_link(num, params)
          end
        end
        html << ".." unless end_number >= current_page.pager.last.number - 1
        html << pagination_ajax_link(current_page.pager.last.number, params) unless end_number == current_page.pager.last.number
        html.join(' ')
      end
    end
  end
end
