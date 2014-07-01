module YamlUtils

  # include another dynamic fixture
  def self.eval_erb_file(path, b = nil)
    require "erb"
    text = IO.read(path)
    template = ERB.new(text, 0, "%<>")
    template.result(b || binding)
  end

end
