require 'lib/convertible_to_csv'

Gem::Specification.new do |s|
  s.name = %q{convertible_to_csv}
  s.version = ConvertibleToCsv::VERSION::STRING
  s.date = `date +%Y-%m-%d`.chomp
  s.summary = %q{convertible_to_csv allows you to send a to_csv method to an ActiveRecord Model object}
  s.email = %q{keith@rubygreenblue.com}
  s.homepage = %q{http://www.rubygreenblue.com/}
  s.autorequire = %q{convertible_to_csv}
  s.has_rdoc = false
  s.authors = ["Keith Rowell"]
  s.files = ["lib/convertible_to_csv.rb"]
  s.bindir = nil
  s.required_ruby_version = nil
  s.platform = nil
  s.requirements = ["active_record"]
end
