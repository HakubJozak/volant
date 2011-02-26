require 'rubygems'
require 'active_record'

module ConvertibleToCsv
  module VERSION
    MAJOR = 0
    MINOR = 3
    TINY  = 0
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end

class ActiveRecord::Base

  def self.acts_as_convertible_to_csv(options = {})

    @@use_header_fields = false


    if options[:header]
      @@use_header_fields = true
    end

    if options[:fields] and options[:fields].is_a? Array
      class_eval <<-CEEND
        def self.csv_header
          %w(#{options[:fields].join(' ')})
        end
      CEEND
    else
      class_eval <<-CEEND
        def self.csv_header
          field_names = Array.new
          self.content_columns.each do |column|
            field_names << column.name
          end
          field_names
        end
      CEEND
    end

    if options[:format_options]
      class_eval <<-CEEND
        def format_functions
          {#{options[:format_options].map { |field_name, function_name| ':' + field_name.to_s + ' => :' + function_name.to_s }.join(', ')}}
        end
      CEEND
    else
      class_eval <<-CEEND
        def format_functions
          nil
        end
      CEEND
    end

    class_eval <<-CEEND
      def self.use_header_fields
        @@use_header_fields
      end

      def to_csv
        line = ""
        self.class.csv_header.each do |field_name|
          if format_functions and format_functions[field_name.intern]
            value = self.send((format_functions[field_name.intern]).to_s, field_name.intern, self.send(field_name))
          elsif String === self.send(field_name) || DateTime === self.send(field_name)
            value = '"' + self.send(field_name) + '"'
          else
            value = self.send(field_name).to_s
          end
          line = line + "," + value
        end
        # remove first ', '
        line.gsub! /^,/, ''
      end
    CEEND
  end

end

# Allow a collection class to repond to to_csv
class Array

  def to_csv(&block)
    data = Array.new
    # check to see if the objects in the array are capable of to_csv
    if self[0] and self[0].class.method_defined?(:to_csv)
      if self[0].class.use_header_fields
        data << self[0].class.csv_header.join(',')
        yield self[0].class.csv_header.join(',') if block_given?
      end
      each do |object|
        data << object.to_csv
        yield object.to_csv if block_given?
      end
    end
    data
  end

end
