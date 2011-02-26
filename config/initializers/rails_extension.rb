class ActiveRecord::Base

  def self.not_null_columns
     exclusion_regexp = /(_at|_on|_id)$|^(id|position|type)$/
     cols = columns.find_all do |col|
       (col.name !~ exclusion_regexp || col.name =~ /_id$/) && !col.null && col.type != :boolean
     end
  end

  # Creates field_string and field_string= methods for all date and date time fields with parsing.
  # TODO - let it be locale sensitive
  def self.create_date_time_accessors(*selected)
    unless selected.empty?
      to_scan = columns.find_all { |c| selected.include?(c.name) }
    else
      to_scan = columns
    end

    to_scan.each do |col|
      case col.type
        when :datetime:
          eval(parser_accessor_code(col.name.to_s, "%d.%m.%Y %H:%M"))

        when :date:
          eval(parser_accessor_code(col.name.to_s, "%d.%m.%Y"))
      end
    end
  rescue => e
    Rails.logger.error "Failed to create date/time accessors #{e}"
  end


  private

  def self.parser_accessor_code(name, format)
    symbol = ':' + name
    validation_result = '@' + name + '_invalid'

    code = %{

      def #{name}_string
        value = read_attribute(\"#{name}\")
        value ? value.strftime("#{format}") : ''
      end

      def #{name}_string=(value)
        result = value.blank? ? nil : DateTime.strptime(value, '#{format}')
        write_attribute(\"#{name}\", result)
      rescue ArgumentError
        #{validation_result} = true
      end

      def validate
        if #{validation_result}
            errors.add(#{symbol}, "is invalid")
        end
      end
    }
  end


end
