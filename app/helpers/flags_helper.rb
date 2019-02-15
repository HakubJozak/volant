module FlagsHelper

  def flag(value, size: :medium)
    if value.is_a? String
       name = value
       code = value.upcase
     elsif value.respond_to?(:country)
       name = value.country.name
       code = value.country.code
     else
       fail "Cannot render flag for #{value}"
    end

    w_h = case size
          when :small then 16
          when :medium then 24
          when :big then 32
          when :huge then 64
          else 24
          end

    url = "flags-iso/flat/#{w_h}/#{code}.png"
    image_tag url, class: 'flag small-flag', alt: name, title: name
  # TODO - catch only missing assets exception
  rescue
    ''
  end

end
