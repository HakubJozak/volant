class AttachmentSerializer < ApplicationSerializer
  attributes :id, :url, :filename
  has_one :message, embed: :ids, include: false

  def filename
    object.file_identifier || '[no-name]'
  end

  def url
    object.file.try(:url)
  end
end
