# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload', override_url: false, apply_css_live: true do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(hbs|emblem))).*}) { |m|
    file = m[3].gsub('hbs','js')
    "/assets/#{file}?body=1"
  }
end
