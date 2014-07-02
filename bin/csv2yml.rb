require 'csv'
require 'yaml'

data = CSV.read(ARGV.first, :headers => true).map(&:to_hash)
puts data.to_yaml
