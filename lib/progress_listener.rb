class ProgressListener

  attr_accessor :errors
  attr_accessor :infos

  def initialize
    @errors = []
    @infos = []
  end

  def error(msg)
    @errors << msg
  end

  def info(msg)
    @infos << msg
  end

end
