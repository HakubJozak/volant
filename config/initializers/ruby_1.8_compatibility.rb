$:.unshift('.')

class I18n::Backend::Simple
  def load_yml(filename)
    YAML::load(File.new(filename))
  end
end
