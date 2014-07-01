class FileAttachment

  attr_reader :uploaded

  def initialize(params)
    @uploaded = params['file']
  end

  def self.create_from_params(params)
    FileAttachment.new(params)
  end

  def form_fields
    []
  end

  def to_label
    uploaded.original_filename
  end

  def to_link
    ''
  end

  def content_type
    uploaded.content_type
  end

  def generate_data
    uploaded.read
  end
end
