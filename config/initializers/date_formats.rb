module ActiveScaffold::Helpers::ViewHelpers
      def active_scaffold_input_calendar_date_select(column, options)
        options[:class] = "#{options[:class]} text-input".strip
        options[:time] = false
        options[:value] = @record.send(column.name)
        calendar_date_select("record", "#{column.name}", options)
      end

      def active_scaffold_input_calendar_time_select(column, options)
        options[:class] = "#{options[:class]} text-input".strip
        options[:time] = true
        options[:value] = @record.send(column.name)
        calendar_date_select("record", "#{column.name}", options)
      end
end



